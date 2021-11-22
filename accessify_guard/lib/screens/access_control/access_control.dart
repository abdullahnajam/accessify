import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guard/model/access/delivery.dart';

import 'package:guard/model/access/employee_frequent_model.dart';
import 'package:guard/model/access/event.dart';
import 'package:guard/model/access/guest.dart';
import 'package:guard/model/access/taxi_model.dart';
import 'package:guard/model/access_control_model.dart';
import 'package:guard/screens/access_control/add_access.dart';
import 'package:guard/utils/custom_dailogs.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
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

  CustomDailog customDailog=new CustomDailog();

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
        customDailog.showFailuresDialog("No record found", context);
      }
    });

  }
  getDeliveryList(String id) async {
    print("added");
    FirebaseFirestore.instance.collection('delivery_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        Delivery delivery = new Delivery(
            documentSnapshot.reference.id,
            data['name'],
            data['date'],
            data['hour'],
            data['status'],
            data['userId']
        );
        Navigator.push(context, new MaterialPageRoute(builder: (context) => AddAccess(id,"event",delivery.userId,delivery.name)));

      }
      else{
        print("not found");
        customDailog.showFailuresDialog("No record found against this QR Code", context);
      }
    });
  }
  getTaxiList(String id) async {
    print("added");
    FirebaseFirestore.instance.collection('taxi_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        TaxiModel taxi = new TaxiModel(
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
        Navigator.push(context, new MaterialPageRoute(builder: (context) => AddAccess(id,"event",taxi.userId,taxi.name)));
      }
      else{
        print("not found");
        customDailog.showFailuresDialog("No record found", context);
      }
    });
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
        customDailog.showFailuresDialog("No record found against this QR Code", context);
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
        customDailog.showFailuresDialog("No record found against this QR Code", context);
      }
    });
  }

  searchDataForDeliveryOrTaxi(String id){
    final ProgressDialog pr = ProgressDialog(context);
    pr.show();
    FirebaseFirestore.instance.collection('access_control').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        AccessControlModel model=AccessControlModel.fromMap(data, documentSnapshot.reference.id);
        if(model.status=="scheduled"){
          if(model.type=="Delivery"){
            getDeliveryList(model.id);
          }
          else if(model.type=="Taxi"){
            getTaxiList(model.id);
          }
        }
        else{
          customDailog.showFailuresDialog("This QR Code is expired", context);
        }
      }
      else {
        print('Document does not exist on the database');
        customDailog.showFailuresDialog("Invalid QR Code", context);


      }
    });
  }

  scanQRCode()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    }
    else {
      final ProgressDialog pr = ProgressDialog(context);
      pr.show();
      print('qr code $barcode');
      FirebaseFirestore.instance.collection('access_control').doc(barcode).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          AccessControlModel model=AccessControlModel.fromMap(data, documentSnapshot.reference.id);
          if(model.status=="scheduled"){
            if(model.type=="Event"){
              pr.hide();
              getEventList(model.id);
            }
            else if(model.type=="Employee" || model.type=="Frequent"){
              pr.hide();
              getEmployeeFrequentList(model.id);
            }

            else if(model.type=="Event"){
              pr.hide();
              getEventList(model.id);
            }
            else if(model.type=="Guest"){
              pr.hide();
              getGuestList(model.id);
            }
            else{
              pr.hide();
              customDailog.showFailuresDialog("Invalid QR - No type found", context);
            }
          }
          else{
            pr.hide();
            customDailog.showFailuresDialog("This QR Code is expired", context);
          }
        }
        else {
          pr.hide();
          print('Document does not exist on the database');
          customDailog.showFailuresDialog("Invalid QR Code", context);


        }
      });

      

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
      backgroundColor: bgColor,
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.33,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: <Widget>[

                    Row(
                      children: [
                        Container(

                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            margin: EdgeInsets.only(top: 10, right: 10,left: 10),
                            child: GestureDetector(
                              onTap: _openDrawer,
                              child: Icon(
                                Icons.menu,
                                color: Colors.blue,
                                size: 30,
                              ),
                            )),
                        Text(
                          "Access Control",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Keep control of the visitors and manage the neighbourhood through accesfy guard app",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            scanQRCode();
                          },
                          child:Container(
                            height: 50,
                            //width: MediaQuery.of(context).size.width*0.5,
                            padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Scan QR Code",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13.0),
                                  ),
                                ),
                                Container(
                                  //color: Colors.grey,
                                  child: Lottie.asset(
                                    'assets/json/scan_qr.json',
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
          Padding(
              padding:
              const EdgeInsets.only(left: 25.0,right: 10, top: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Access Log",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  ),


                ],
              )
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            insetAnimationDuration: const Duration(seconds: 1),
                            insetAnimationCurve: Curves.fastOutSlowIn,
                            elevation: 2,

                            child: Container(
                              margin: EdgeInsets.only(left: 15,right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text("Delivery",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('access_control')
                                        .where("status", isEqualTo:"scheduled")
                                        .where("type",isEqualTo:"Delivery").snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Column(
                                            children: [
                                              Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                              Text("Something Went Wrong")

                                            ],
                                          ),
                                        );
                                      }

                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (snapshot.data.size==0){
                                        return Center(
                                          child: Column(
                                            children: [
                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                              Text("No Deliveries")

                                            ],
                                          ),
                                        );

                                      }

                                      return new ListView(
                                        shrinkWrap: true,
                                        children: snapshot.data.docs.map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                          return GestureDetector(
                                            onTap: (){
                                             searchDataForDeliveryOrTaxi(document.reference.id);
                                            },
                                            child: ListTile(
                                              title: Text(data['requestedFor']),
                                              subtitle: Text("${data['date']}"),
                                            )
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delivery_dining,size: 40,color: Colors.blue,),
                          SizedBox(height: 10,),
                          Text('Delivery Access',style: TextStyle(fontSize: 10),)

                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            insetAnimationDuration: const Duration(seconds: 1),
                            insetAnimationCurve: Curves.fastOutSlowIn,
                            elevation: 2,

                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text("Taxi",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('access_control')
                                        .where("status", isEqualTo:"scheduled")
                                        .where("type",isEqualTo:"Taxi").snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Column(
                                            children: [
                                              Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                              Text("Something Went Wrong")

                                            ],
                                          ),
                                        );
                                      }

                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (snapshot.data.size==0){
                                        return Center(
                                          child: Column(
                                            children: [
                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                              Text("No Taxi")

                                            ],
                                          ),
                                        );

                                      }

                                      return new ListView(
                                        shrinkWrap: true,
                                        children: snapshot.data.docs.map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                          return GestureDetector(
                                              onTap: (){
                                                searchDataForDeliveryOrTaxi(document.reference.id);
                                              },
                                              child: ListTile(
                                                title: Text(data['requestedFor']),
                                                subtitle: Text("${data['date']}"),
                                              )
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 15),
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_taxi,size: 40,color: Colors.blue,),
                          SizedBox(height: 10,),
                          Text('Taxi Access',style: TextStyle(fontSize: 10),)

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('access_control')
                  .orderBy("datePostedInMilli",descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.size==0){
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset("assets/json/empty.json",width: 150,height: 150,),
                        Text("No Access Request")

                      ],
                    ),
                  );
                }
                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    AccessControlModel model=AccessControlModel.fromMap(data, document.reference.id);
                    return new Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),

                            margin: EdgeInsets.fromLTRB(10,10,10,0),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${model.type} - ${model.requestedFor}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),


                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(model.date,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),
                                    Text(model.status,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                    //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                  ],
                                ),

                              ],
                            ),
                          ),
                        )
                    );
                  }).toList(),
                );
              },
            ),
          )


        ],
      ),
    );
  }
}
