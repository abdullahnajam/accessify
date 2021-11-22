import 'package:accessify/constants.dart';
import 'package:accessify/screens/access_control/main_screen.dart';
import 'package:accessify/screens/annoucments/announcement.dart';
import 'package:accessify/screens/bottom_nav_screens/create.dart';
import 'package:accessify/screens/bottom_nav_screens/main_menu.dart';
import 'package:accessify/screens/bottom_nav_screens/notifications.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/payments/my_payments.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{

  int _currentIndex = 1;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = [
      Announcements(),
      MainMenuScreen(),
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
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: bgColor,
        index: 1,
        color: Colors.blue,
        items: <Widget>[

          Icon(Icons.announcement,color: Colors.white, size: 30),
          Icon(Icons.home,color: Colors.white, size: 30),
          Icon(Icons.notifications,color: Colors.white, size: 30),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        },
      ),
      body: _children[_currentIndex],
    );
  }
}
