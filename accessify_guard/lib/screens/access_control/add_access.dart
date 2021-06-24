import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/model/access/delivery.dart';
import 'package:guard/model/access/employee_frequent_model.dart';
import 'package:guard/model/access/event.dart';
import 'package:guard/model/access/guest.dart';
import 'package:guard/model/access/taxi_model.dart';
import 'package:guard/model/notification_model.dart';
import 'package:guard/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';
class AddAccess extends StatefulWidget {
  String barcode,type,userId,name;

  AddAccess(this.barcode,this.type,this.userId,this.name);

  @override
  _AddAccessState createState() => _AddAccessState();
}

class _AddAccessState extends State<AddAccess> {
  Delivery delivery;
  EventModel event;
  GuestModel guest;
  TaxiModel taxi;
  EmployeeAccessModel employee;

  getEmployeeFrequentList() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("employee").child(widget.barcode).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var DATA=dataSnapshot.value; 
        setState(() {
          employee= new EmployeeAccessModel(
            dataSnapshot.key,
            DATA['emp'],
            DATA['qr'],
            DATA['fromDate'],
            DATA['expDate'],
            DATA['userId'],
            DATA['type'],
          );
        });
      }
    });
  }


  getDeliveryList() async {
    print("added");
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("delivery").child(widget.barcode).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var DATA=dataSnapshot.value;

         setState(() {
           delivery = new Delivery(
               dataSnapshot.key,
               DATA['name'],
               DATA['date'],
               DATA['hour'],
               DATA['status'],
               DATA['userId']
           );
           print("addeddd ${widget.barcode} ${delivery.id}");
         });
      }
    });

  }
  getGuestList() async {
    List<GuestModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("guest").child(widget.barcode).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var DATA=dataSnapshot.value;

        setState(() {
          guest=new GuestModel(
            dataSnapshot.key,
            DATA['name'],
            DATA['email'],
            DATA['date'],
            DATA['hour'],
            DATA['status'],
            DATA['userId'],
            DATA['vehicle'],
            DATA['qr'],
          );
        });
      }
    });
    return list;
  }


  Future<UserModel> getUserData()async{
    UserModel userModel;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("users").child(widget.userId).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        print(dataSnapshot.value);
        userModel = new UserModel(
            dataSnapshot.key,
            dataSnapshot.value['name'],
            dataSnapshot.value['email'],
            dataSnapshot.value['type'],
            dataSnapshot.value['isActive'],
            dataSnapshot.value['token']
        );
        print("username = ${userModel.username}");
      }
    });
    return userModel;
  }
  @override
  void initState() {
    super.initState();
    print("in init");
    getDeliveryList();
    getGuestList();
    getEmployeeFrequentList();
    getEventList();
  }
  getEventList() async {
    List<EventModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("event").child(widget.barcode).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;
        setState(() {
          event= new EventModel(
          dataSnapshot.key,
          DATA['name'],
          DATA['location'],
          DATA['date'],
          DATA['startTime'],
          DATA['guests'],
          DATA['qr'],
          DATA['userId'],
          );
        });
      }
    });
    return list;
  }

  sendNotification(String userToken,userId) async{
    print("token $userToken");
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${widget.type} access',
            'title': '${widget.type} access granted for ${widget.name}'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "$userToken",
        },
      ),
    ).whenComplete(()  {
      User user=FirebaseAuth.instance.currentUser;
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child("notifications").child("guard").child(widget.barcode).update({
        'isOpened': true,
      });
      //final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child("notifications").child("user").push().set({

        'isOpened': false,
        'type':widget.type,
        'date':DateTime.now().toString(),
        'body':'${widget.type} access granted ${widget.name}',
        'title':"${widget.type} access",
        'icon':'https://img.icons8.com/officel/80/000000/user-credentials.png',
        'userId':userId
      }).whenComplete(() => Navigator.pop(context));

    });
  }
  List<String> urls=[];
  addAccessToDb(String token,userId){
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("access_log").push().set({

      'name': widget.name,
      'id':widget.barcode,
      'type':widget.type,
      'date':DateTime.now().toString(),
      'userId':widget.userId,
      'scanId':idNumberController.text,
      'vehiclePlate':plateController.text,
      'images':urls
    }).then((value) => sendNotification(token,userId)).catchError((onError){
      Toast.show(onError.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    });
  }
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
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  List<File> _imageFiles=[];
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFiles.add(File(pickedFile.path));
      print("file1 = ${_imageFiles[_imageFiles.length-1].path}");
    });

    uploadImageToFirebase(context,_imageFiles[_imageFiles.length-1]);
  }
  final idNumberController=TextEditingController();
  final plateController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder<UserModel>(
            future: getUserData(),
            builder: (context,snapshot){
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Form(
                    key: _formKey,
                    child: ListView(

                      children: [

                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                            ),

                          ),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("Register Access",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                              ),


                            ],
                          ),
                        ),
                        event!=null?Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Event Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                                SizedBox(height: 10,),
                                Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${event.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Location",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${event.location}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${event.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                                SizedBox(height: 10,),
                                Text("Start Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${event.startTime}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                                SizedBox(height: 10,),
                                Text("QR Code",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(event.qr),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),





                              ],
                            )

                        ):Container(),
                        guest!=null? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Guest Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                                SizedBox(height: 10,),
                                Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${guest.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Email",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${guest.email}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Vehicle",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${guest.vehicle}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                                SizedBox(height: 10,),
                                Text("Start Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${guest.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Start Hour",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${guest.hour}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("QR Code",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(guest.qr),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),





                              ],
                            )

                        ):Container(),
                        employee!=null? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Employee/Frequent Information",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                                SizedBox(height: 10,),
                                Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${employee.emp}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                                SizedBox(height: 10,),
                                Text("Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${employee.fromDate} - ${employee.expDate}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),





                                SizedBox(height: 10,),
                                Text("QR Code",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(employee.qr),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),





                              ],
                            )

                        ):Container(),
                        delivery!=null?Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Delivery Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                                SizedBox(height: 10,),
                                Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${delivery.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Start Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${delivery.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                SizedBox(height: 10,),
                                Text("Start Hour",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                                Text("${delivery.hour}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),






                              ],
                            )

                        ):Container(),
                        Container(
                          margin:EdgeInsets.only(top: 30,left: 10),
                          child: Text(
                            "Please fill the form to add the user",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: 50,),
                        TextFormField(
                          controller: idNumberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.contact_mail_outlined,color: Colors.black,size: 22,),
                            fillColor: Colors.grey[200],
                            hintText: "Enter ID Number",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: plateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.car_repair,color: Colors.black,size: 22,),
                            fillColor: Colors.grey[200],
                            hintText: "Enter Vehicle Number",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                        SizedBox(height: 30,),

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
                        Container(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: ()=>pickImage(),
                            color: kPrimaryColor,
                            child: Text("Add Image",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        _imageFiles.length>0?Container(
                          height: 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageFiles.length,
                            itemBuilder: (BuildContext context,int index){
                              return Container(
                                height: 60,
                                width: 60,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: FileImage(_imageFiles[index]),
                                        fit: BoxFit.cover
                                    )
                                ),
                              );
                            },
                          ),
                        ):Container(),

                        SizedBox(height: 20,),
                        Container(
                          child: DefaultButton(
                            text: "Continue",
                            press: () {
                              if (_formKey.currentState.validate()) {
                                print(urls.length);
                                if(urls.length>0){

                                  addAccessToDb(snapshot.data.token,snapshot.data.id);
                                }
                                else{
                                  if(_imageFiles.length==0)
                                    Toast.show("Please add an image", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                  else
                                    Toast.show("Image uploading", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                }
                              }

                            },
                          ),
                          margin: EdgeInsets.all(10),
                        )
                      ],
                    ),
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
        )
      ),
    );
  }
}
