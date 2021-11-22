import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/alert_model.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:toast/toast.dart';
class NotifyResidents extends StatefulWidget {
  @override
  _NotifyResidentsState createState() => _NotifyResidentsState();
}

class _NotifyResidentsState extends State<NotifyResidents> {
  final _formKey = GlobalKey<FormState>();
  String startDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String url;
  sendNotification() async{
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
            'body': 'Service Alert',
            'title': '$alertSelected scheduled at $startDate'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/resident",
        },
      ),
    ).whenComplete(()  {
      FirebaseFirestore.instance.collection("notifications").add({

        'isOpened': false,
        'type':"service",
        'name':"Service Alert",
        'date':DateTime.now().toString(),
        'body':'$alertSelected scheduled at $startDate',
        'title':"Service Alert",
        'icon':url,
        'userId':"all"
      });

    }).then((value) => Toast.show("Notification Sent", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM));
  }

  String alertSelected="Select Service List",selectedAlertId;
  Future<void> _showAlertsDailog() async {
    return showDialog<void>(
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
                  child: Text("Services List",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('services').snapshots(),
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
                            Text("No Services")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return ListTile(
                          onTap: (){
                            setState(() {
                              alertSelected=data['name'];
                              selectedAlertId=document.reference.id;
                              url=data['image'];
                            });
                            Navigator.pop(context);
                          },
                          leading: Image.network(data['image']),
                          title: Text(data['name'],textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),
                          ),
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.15, color: kPrimaryColor),
                ),
              ),
              height:  AppBar().preferredSize.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Notify Residents',style: TextStyle(color: kPrimaryColor),),
                  )
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, top: 40.0, bottom: 10.0),
              child: Text(
                "Fill the Information",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 25,right: 25,top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top:15,bottom:15,left:10,right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(Icons.notifications_none,color: Colors.black,size: 22,),
                            ),

                            Expanded(
                                flex: 9,
                                child: Container(
                                  padding: EdgeInsets.only(left:12),
                                  child:InkWell(
                                      onTap: (){
                                        _showAlertsDailog();
                                      },
                                      child:Text(alertSelected)
                                  ),
                                )
                            )
                          ],
                        )
                    ),

                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){

                        if (_formKey.currentState.validate()) {
                          sendNotification();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Text("Send Notification",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
