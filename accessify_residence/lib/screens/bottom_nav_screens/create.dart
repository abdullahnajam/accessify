import 'package:accessify/navigator/menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: SafeArea(
        child: ListView(
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
                      "Choose To Create",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                )),
            SizedBox(height: 30,),
            Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: null,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 20.0, top: 0.0),
                        child: Container(
                          height: 55.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(70.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              color: Colors.white),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Text(
                                  "Incident",
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
                                Icons.dangerous,
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
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: null,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 20.0, top: 0.0),
                        child: Container(
                          height: 55.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(70.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              color: Colors.white),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Text(
                                  "Reservation",
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
                                Icons.calendar_today,
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
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: null,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 20.0, top: 0.0),
                        child: Container(
                          height: 55.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(70.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              color: Colors.white),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Text(
                                  "Suggestion",
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
                                Icons.note,
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
            ),

          ],
        ),
      ),
    );
  }
}
