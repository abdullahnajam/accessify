import 'package:accessify/constants.dart';
import 'package:accessify/navigator/bottom_navigation.dart';
import 'package:accessify/screens/bottom_nav_screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class Home extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BottomBar();
  }
}
