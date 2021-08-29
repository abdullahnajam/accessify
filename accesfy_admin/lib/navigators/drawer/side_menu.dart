
import 'package:accesfy_admin/navigators/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        color: bgColor,
        child:ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/icons/logo.png"),
            ),
            DrawerListTile(
              title: "Neighbours",
              svgSrc: "assets/icons/dashboard.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));

              },
            ),
            DrawerListTile(
              title: "Board Members",
              svgSrc: "assets/icons/guard.png",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BoardScreen()));
              },
            ),

          ],
        ),
      )
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
