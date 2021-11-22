import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  bool isUserDataLoaded=false;
  UserModel model;

  getDeliveryList() async {
    print("added");
    FirebaseFirestore.instance.collection('delivery_access').doc(widget.barcode).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        delivery = new Delivery(
          documentSnapshot.reference.id,
            data['name'],
            data['date'],
            data['hour'],
            data['status'],
            data['userId']
        );
      }
    });
  }
  getTaxiList() async {
    print("added");
    FirebaseFirestore.instance.collection('taxi_access').doc(widget.barcode).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        taxi = new TaxiModel(
            documentSnapshot.reference.id,
            data['name'],
            data['date'],
            data['hour'],
            data['status'],
            data['userId'],
          data['description'],
          data['omw'],
          data['pickup'],
        );
      }
    });
  }
  getEventList() async {
    FirebaseFirestore.instance.collection('event_access').doc(widget.barcode).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        event = new EventModel(
          documentSnapshot.reference.id,
          data['name'],
          data['location'],
          data['date'],
          data['startTime'],
          data['guests'],
          data['qr'],
          data['userId'],
          data['status'],
        );
      }
    });

  }
  getEmployeeFrequentList() async {
    FirebaseFirestore.instance.collection('employee_access').doc(widget.barcode).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        employee = new EmployeeAccessModel(
          documentSnapshot.reference.id,
          data['emp'],
          data['qr'],
          data['fromDate'],
          data['expDate'],
          data['userId'],
          data['type'],
          data['status'],
        );
      }
    });

  }
  getGuestList() async {
    FirebaseFirestore.instance.collection('guest_access').doc(widget.barcode).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        guest = new GuestModel(
          documentSnapshot.reference.id,
          data['name'],
          data['email'],
          data['date'],
          data['hour'],
          data['status'],
          data['userId'],
          data['vehicle'],
          data['qr'],
        );
      }
    });

  }
  getUserData()async{

    print("my user id ${widget.userId}");
    FirebaseFirestore.instance.collection('homeowner').doc(widget.userId).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          model=UserModel.fromMap(data,documentSnapshot.reference.id);
          isUserDataLoaded=true;
        });
      }
      else{
        return null;
      }
    });

  }

  @override
  void initState() {
    super.initState();
    print("in init");
    getDeliveryList();
    getGuestList();
    getEmployeeFrequentList();
    getEventList();
    getUserData();
    getTaxiList();
  }


  sendNotification(String userToken,userId) async{
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
      FirebaseFirestore.instance.collection("guard_notifications").doc(widget.barcode).update({
        'isOpened': true,
      });
      FirebaseFirestore.instance.collection("notifications").add({
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
   FirebaseFirestore.instance.collection("access_log").add({
      'name': widget.name,
      'id':widget.barcode,
      'type':widget.type,
      'date':DateTime.now().toString(),
      'userId':widget.userId,
      'scanId':idNumberController.text,
      'vehiclePlate':plateController.text,
      'images':urls
    }).then((value) {
     sendNotification(token,userId);
     String path;
     if(delivery!=null)
       path="delivery_access";
     else if(event!=null)
       path="event_access";
     else if(guest!=null)
       path="guest_access";
     else if(taxi!=null)
       path="taxi_access";
     else if(employee!=null)
       path="employee_access";
     FirebaseFirestore.instance.collection(path).doc(widget.barcode).update({
       "status":"Accessed"
     });
     FirebaseFirestore.instance.collection("access_control").doc(widget.barcode).update({
       "status":"Accessed"
     });
   }).catchError((onError){
      Toast.show(onError.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    });
  }
  Future uploadImageToFirebase(BuildContext context,File file) async {
    String fileName = file.path;
    final ProgressDialog pr = ProgressDialog(context);
    pr.show();

    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      await snapshot.ref.getDownloadURL().then((value) {
        setState(() {
          print(value);
          urls.add(value.toString());
        });
      });

    }
    pr.hide();
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
          child:isUserDataLoaded?
          Form(
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
                taxi!=null?Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Taxi Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${taxi.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${taxi.description}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Start Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${taxi.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Start Hour",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${taxi.hour}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),






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

                          addAccessToDb(model.token,model.id);
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
    ):Center(
            child: Lottie.asset(
              'assets/json/loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

        )
      ),
    );
  }
}
