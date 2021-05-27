import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guard/constants.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:guard/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/screens/inventory/inventory.dart';
import 'package:guard/screens/members/members.dart';
import 'package:guard/screens/reservations/reservations.dart';
import 'package:overlay_support/overlay_support.dart';

import 'access_control/access_control.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';



  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
          setState(() => _message = message["notification"]["body"]);
          showOverlayNotification((context) {
            return Card(
              margin: EdgeInsets.all(10),
              child: SafeArea(
                child: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      }),
                ),
              ),
            );
          }, duration: Duration(milliseconds: 4000));
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["body"]);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getMessage();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      backgroundColor: kPrimaryLightColor,
      body: ListView(
        children: [

          Container(
              margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: GestureDetector(
                        onTap: _openDrawer,
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                      )),
                  Text(
                    "Accessify",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              "All the administration of your neighborhood will be literally in the palm of your hand.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => AccessControl()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/access.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Text(
                          "Access Control",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        )),
                  )
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => Members()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/member.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Text(
                          "Members",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        )),
                  )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => Reservations()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/reserve.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Text(
                          "Reservations",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        )),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => Inventory()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage('assets/images/report.png',),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Text("Inventory",style: TextStyle(color: kPrimaryColor,fontSize: 22,fontWeight: FontWeight.w800),textAlign: TextAlign.center,)
                    ),
                  ))
            ],
          )

        ],
      ),
    );
  }
}
