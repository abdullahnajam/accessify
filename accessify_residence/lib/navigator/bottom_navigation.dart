import 'package:accessify/constants.dart';
import 'package:accessify/screens/bottom_nav_screens/create.dart';
import 'package:accessify/screens/bottom_nav_screens/main_menu.dart';
import 'package:accessify/screens/bottom_nav_screens/notifications.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/payments/my_payments.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = [
      MainMenuScreen(),
      Create(),
      Notifications(),

    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor:Color(0xffabc6ff),
        selectedItemColor: kPrimaryColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add),
              title: Text("Create")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Notification")
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
