import 'package:guard/constants.dart';
import 'package:guard/navigator/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:guard/screens/main_menu.dart';
class Home extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MainMenuScreen();
  }
}
