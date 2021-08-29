import 'package:accesfy_admin/responsive.dart';
import 'package:accesfy_admin/screens/board_members/board_members.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer/side_menu.dart';

class BoardScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: BoardPanelMembers(_scaffoldKey),
            ),
          ],
        ),
      ),
    );
  }
}
