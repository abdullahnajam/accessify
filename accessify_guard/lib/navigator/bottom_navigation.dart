import 'package:guard/constants.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:guard/screens/access_control/access_control.dart';
import 'package:guard/screens/notifications.dart';
import 'package:guard/screens/notify_residents.dart';
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
      NotifyResidents(),
      AccessControl(),
      Notifications()

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
      backgroundColor: bgColor,
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: bgColor,
        index: 1,
        color: Colors.blue,
        items: <Widget>[

          Icon(Icons.home,color: Colors.white, size: 30),
          Icon(Icons.qr_code,color: Colors.white, size: 30),
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
