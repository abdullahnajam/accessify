import 'package:accessify/constants.dart';
import 'package:accessify/screens/access_control/main_screen.dart';
import 'package:accessify/screens/bottom_nav_screens/create.dart';
import 'package:accessify/screens/bottom_nav_screens/main_menu.dart';
import 'package:accessify/screens/bottom_nav_screens/notifications.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/payments/my_payments.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';

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
      AccessControl(),
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
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        animationDuration: Duration(milliseconds: 800),
        animationCurve: Curves.linear,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [

          FlashyTabBarItem(
            icon: Icon(Icons.vpn_key_outlined),
            title: Text('Access Control'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            title: Text('Notifications'),
          ),

        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
