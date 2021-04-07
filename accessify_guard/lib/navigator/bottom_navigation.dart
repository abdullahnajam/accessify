import 'package:guard/constants.dart';
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
      Container(),
      Container(),
      Container()

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
              icon: Icon(Icons.notifications),
              title: Text("Notification")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              title: Text("Scan QR")
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
