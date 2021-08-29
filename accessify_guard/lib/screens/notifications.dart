import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/access/employee_frequent_model.dart';
import 'package:guard/model/access/event.dart';
import 'package:guard/model/access/guest.dart';
import 'package:guard/model/notification_model.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:guard/screens/access_control/add_access.dart';
import 'package:guard/screens/addAccessControlMember.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:toast/toast.dart';
class Notifications extends StatefulWidget {
  @override
  _AccessControlState createState() => _AccessControlState();
}

class _AccessControlState extends State<Notifications> {

  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }





  Future<EventModel> getEventList(String id) async {
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
      }
    });
    
    return eventModel;
  }
  Future<EmployeeAccessModel> getEmployeeFrequentList(String id) async {
    EmployeeAccessModel empfrequentModel;
    User user=FirebaseAuth.instance.currentUser;
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
      }
    });

    return empfrequentModel;
  }
  Future<GuestModel> getGuestList(String id) async {
    GuestModel guestModel;
    FirebaseFirestore.instance.collection('guest_access').doc(id).get().then((DocumentSnapshot documentSnapshot) {
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
      }
    });

    return guestModel;
  }

  String qrcode;

  showDeliveryServiceDailog(String type)async{

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

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
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
                                  "Notifications",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),


                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('guard_notifications').snapshots(),
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
                            Text("No Notifications")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        NotificationModel model=NotificationModel(
                          document.reference.id,
                          data['isOpened'],
                          data['type'],
                          data['date'],
                          data['body'],
                          data['title'],
                          data['icon'],
                          data['userId'],
                          data['name'],
                        );
                        return Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InkWell(
                              onTap: (){
                                if(model.type=="delivery" || model.type=="taxi"){
                                  print("${model.id} id");
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => AddAccess(model.id, model.type,  model.userId,  model.name)));
                                }
                                else{
                                  showDeliveryServiceDailog(model.type);
                                }
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(width: 0.2, color: Colors.grey[500]),
                                  ),

                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child:Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(model.icon),
                                                )
                                            )
                                        )


                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(model.title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                              Text(model.body,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                                            ],
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              model.date==null?Text(""):Text(timeAgoSinceDate(model.date),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                                              Text(model.type,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                                            ],
                                          ),
                                        )
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
              ),





              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _card() {
    return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: InkWell(
          onTap: (){

          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child:Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage("https://image.freepik.com/free-vector/society-concept-illustration_1284-8297.jpg"),
                            )
                        )
                    )


                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Title",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                          Text("Description",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                        ],
                      ),
                    )
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1 hour ago",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          Text("Announcement",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                        ],
                      ),
                    )
                ),

              ],
            ),
          ),
        )
    );
  }
}
