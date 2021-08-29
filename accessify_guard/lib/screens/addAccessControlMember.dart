import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guard/model/access/employee_frequent_model.dart';
import 'package:guard/model/access/event.dart';
import 'package:guard/model/access/guest.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/model/notification_model.dart';
import 'package:guard/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
class AddAccessControlMember extends StatefulWidget {
  NotificationModel notificationModel;

  AddAccessControlMember(this.notificationModel);

  @override
  _AddAccessControlMemberState createState() => _AddAccessControlMemberState();
}

class _AddAccessControlMemberState extends State<AddAccessControlMember> {

  sendNotification(String token) async{
    String url='https://fcm.googleapis.com/fcm/send';
    Uri myUri = Uri.parse(url);
    await http.post(
      myUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${widget.notificationModel.type} Access Granted',
            'title': 'Your ${widget.notificationModel.type} has been granted access by the guard'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    ).whenComplete(()  {
      Navigator.pop(context);
      /*User user=FirebaseAuth.instance.currentUser;
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child("notifications").child("guard").push().set({

        'isOpened': false,
        'type':"Taxi",
        'date':DateTime.now().toString(),
        'body':'Taxi Access from ${userModel.username}',
        'title':"Taxi Access",
        'icon':'https://cdn1.iconfinder.com/data/icons/logistics-transportation-vehicles/202/logistic-shipping-vehicles-002-512.png',
        'userId':user.uid
      });*/

    });
  }






  Future<String> getUserData()async{
    String token;
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('homeowner').doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        token=data['token'];
      }
    });
    return token;
  }


  final idNumberController=TextEditingController();
  final plateController=TextEditingController();
  List<String> urls=[];
  Future uploadImageToFirebase(BuildContext context,File file) async {
    String fileName = file.path;


    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        urls.add(downloadUrl);
      });
    }
  }
  final picker = ImagePicker();
  File _imageFile,_imageFile2,_imageFile3;
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
      print("file1 = ${_imageFile.path}");
    });
    uploadImageToFirebase(context,_imageFile);
  }
  Future pickImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile2 = File(pickedFile.path);
    });
    uploadImageToFirebase(context,_imageFile2);
  }
  Future pickImage3() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile3 = File(pickedFile.path);
    });
    uploadImageToFirebase(context,_imageFile3);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<String>(
            future: getUserData(),
            builder: (context,snapshot){
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,),
                      Container(
                        margin:EdgeInsets.only(top: 5),
                        child: Text(
                          "Please fill in the information to provide access control",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0),
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 30,),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: idNumberController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "ID Number",

                            // If  you are using latest
                            // version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: plateController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Vehicle Plate",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      Container(
                        margin:EdgeInsets.only(top: 5),
                        child: Text(
                          "Photo Evidence",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0),
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: _imageFile==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile,width: 60,height: 60,),
                          ),
                          GestureDetector(
                            onTap: pickImage2,
                            child: _imageFile2==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile2,width: 60,height: 60,),
                          ),
                          GestureDetector(
                            onTap: pickImage3,
                            child: _imageFile3==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile3,width: 60,height: 60,),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: DefaultButton(
                          text: "Continue",
                          press: () {
                            sendNotification(snapshot.data);
                          },
                        ),
                        margin: EdgeInsets.all(10),
                      )
                    ],
                  );
                }
                else {
                  return new Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Text("Unable to load data")
                    ),
                  );
                }
              }
              else if (snapshot.hasError) {
                return Text('Error : ${snapshot.error}');
              } else {
                return new Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      )
    );
  }
}
