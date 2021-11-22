import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard/auth/sign_in/sign_in_screen.dart';
import 'package:guard/data/img.dart';
import 'package:guard/data/my_colors.dart';
import 'package:guard/screens/access_control/access_control.dart';
import 'package:guard/screens/chat_telegram.dart';
import 'package:guard/screens/chathead.dart';
import 'package:guard/screens/home.dart';
import 'package:guard/screens/inventory/inventory.dart';
import 'package:guard/screens/members/members.dart';
import 'package:guard/screens/notifications.dart';
import 'package:guard/screens/notify_residents.dart';
import 'package:guard/screens/reservations/reservations.dart';
import 'package:guard/widget/my_text.dart';
import 'package:guard/widget/toolbar.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: 30),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: MyColors.grey_20,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  Container(height: 7),
                  Text("Accesfy Guard", style: MyText.body2(context).copyWith(
                      color: Colors.blueGrey[800], fontWeight: FontWeight.w500
                  )),

                ],
              ),
            ),
            Container(height: 8),

            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Members()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.people_outline, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Members", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),

            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => AccessControl()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.vpn_key_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Access Control", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => NotifyResidents()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.notifications_active_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Service Alerts", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Reservations()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Reservations", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            /*Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Chat()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.message_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Chats", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),*/
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Inventory()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.category_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Inventory", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Notifications()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.notifications_none, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Notifications", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: () async{
              await FirebaseAuth.instance.signOut().whenComplete((){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
              });
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.power_settings_new, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Logout", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
