import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:guard/model/access/employee_frequent_model.dart';
import 'package:guard/model/access/event.dart';
import 'package:guard/model/access/guest.dart';
import 'package:guard/screens/access_control/add_access.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:toast/toast.dart';
class AccessControl extends StatefulWidget {
  @override
  _AccessControlState createState() => _AccessControlState();
}

class _AccessControlState extends State<AccessControl> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }

  String qrcode;
  showDialog(){
    final idNumberController=TextEditingController();
    final plateController=TextEditingController();
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.2,
                      bottom: MediaQuery.of(context).size.height*0.25,
                      left: MediaQuery.of(context).size.width*0.1,
                      right: MediaQuery.of(context).size.width*0.1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                margin:EdgeInsets.only(top: 5),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.0),
                                ),
                                alignment: Alignment.center,
                              ),
                              GestureDetector(
                                onTap: ()=>Navigator.pop(context),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.all(10),
                                  child: Icon(Icons.close,size: 24,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: idNumberController,
                            decoration: InputDecoration(
                              hintText: "ID Number",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
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
                            keyboardType: TextInputType.text,
                            controller: plateController,
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
                            Container(
                              child: Image.asset('assets/images/add.png',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: DefaultButton(
                            text: "Continue",
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                          margin: EdgeInsets.all(10),
                        )
                      ],
                    )
                )
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
  }

  getEventList(String id) async {
    EventModel eventModel;
    FirebaseFirestore.instance.collection('event_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        eventModel = new EventModel(
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
        Navigator.push(context, new MaterialPageRoute(builder: (context) => AddAccess(id,"event",eventModel.userId,eventModel.name)));
      }
      else{
        print("not found");
        Toast.show("This barcode is not for event access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        return null;
      }
    });

    return eventModel;
  }
  getEmployeeFrequentList(String id) async {
    EmployeeAccessModel empfrequentModel;
    FirebaseFirestore.instance.collection('employee_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        empfrequentModel = new EmployeeAccessModel(
          documentSnapshot.reference.id,
          data['emp'],
          data['qr'],
          data['fromDate'],
          data['expDate'],
          data['userId'],
          data['type'],
          data['status'],
        );
        Navigator.push(context, new MaterialPageRoute(builder: (context) => AddAccess(id,"employee",empfrequentModel.userId,empfrequentModel.emp)));
      }
      else{
        print("not found");
        Toast.show("This barcode is not for employees access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        return null;
      }
    });

  }
  getGuestList(String id) async {
    GuestModel guestModel;
    FirebaseFirestore.instance.collection('guest_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        guestModel = new GuestModel(
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
        Navigator.push(context, new MaterialPageRoute(builder: (context) => AddAccess(id,"guest",guestModel.userId,guestModel.name)));
      }
      else{
        print("not found");
        Toast.show("This barcode is not for guest access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        return null;
      }
    });
  }

  addDeliveryAndTaxiAccess(){

  }

  scanQRCode(String type)async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
      if(type=="event"){
        getEventList(barcode).then((value){
          if(value!=null){
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => AddAccess(barcode,type,value.userId,value.name)));
          }
          else
            Toast.show("This barcode is not for event access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        });
      }
      if(type=="employee"){
        getEmployeeFrequentList(barcode).then((value){
          if(value!=null){
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => AddAccess(barcode,type,value.userId,value.emp)));
          }
          else
            Toast.show("This barcode is not for employee access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        });
      }
      if(type=="guest"){
        getGuestList(barcode).then((value){
          if(value!=null){
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => AddAccess(barcode,type,value.userId,value.name)));
          }
          else
            Toast.show("This barcode is not for guest access", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        });
      }
      

    }

  }
  showUnRegisteredDialog(){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.2,
                      bottom: MediaQuery.of(context).size.height*0.2,
                      left: MediaQuery.of(context).size.width*0.1,
                      right: MediaQuery.of(context).size.width*0.1,
                    ),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.0),
                                ),
                                alignment: Alignment.center,
                              ),
                              GestureDetector(
                                onTap: ()=>Navigator.pop(context),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.all(10),
                                  child: Icon(Icons.close,size: 24,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Visitor Name",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          height: 60,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Contact Name",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "ID Number",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Vehicle Plate",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Address",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery",style: TextStyle(
                                  fontSize: 16.0),),
                              Checkbox(value: false, onChanged: null),

                            ],
                          ),
                        ),

                        Container(
                          margin:EdgeInsets.only(top: 5),
                          child: Text(
                            "Photo Order",
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
                            Container(
                              child: Image.asset('assets/images/add.png',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: DefaultButton(
                            text: "Request Approval",
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                          margin: EdgeInsets.all(10),
                        )
                      ],
                    )
                )
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[

                  Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Center(
                      child: Container(
                        height: 120.0,
                        width: 310.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12.withOpacity(0.1)),
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Container(

                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(50)),
                                    margin: EdgeInsets.only(top: 10, right: 10,left: 10),
                                    child: GestureDetector(
                                      onTap: _openDrawer,
                                      child: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )),
                                Text(
                                  "Access Control",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Keep control of the visitors",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0),
                              ),
                              padding: EdgeInsets.only(left: 20,right: 20),
                            )

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 25.0,right: 10, top: 40.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0),
                    ),
                    Text(
                      "View    ",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0),
                    ),

                  ],
                )
              ),


              _card(Icons.delivery_dining, "Delivery", () =>scanQRCode("guest")),
              _card(Icons.local_taxi, "Taxi", () =>scanQRCode("guest")),
              _card(Icons.people, "Guest", () =>scanQRCode("guest")),
              _card(Icons.card_travel, "Frecuent / Employee", () =>scanQRCode("employee")),
              _card(Icons.event, "Event", () =>scanQRCode("event")),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _card(IconData _icon, String title, GestureTapCallback onTap) {
    return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 20.0, top: 0.0),
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(70.0)),
                      color: Colors.white),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.w300,
                              fontSize: 15.5,color: Colors.black),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 55.0,
                    width: 55.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Center(
                      child: Icon(
                        _icon,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
