import 'package:accessify/constants.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:accessify/screens/access_control/main_screen.dart';
import 'package:accessify/screens/home.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
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
                        builder: (context) => MyHome()));
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
                                'assets/images/home.png',
                              ),
                              fit: BoxFit.cover)),
                      child: Text(
                        "My Home",
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
                          builder: (context) => ViewReservations()));
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
                          builder: (context) => ViewIncidents()));
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
                        child: Text("Incidents",style: TextStyle(color: kPrimaryColor,fontSize: 22,fontWeight: FontWeight.w800),textAlign: TextAlign.center,)
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}