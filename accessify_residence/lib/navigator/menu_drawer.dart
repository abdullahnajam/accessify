import 'package:accessify/auth/sign_in/sign_in_screen.dart';
import 'package:accessify/screens/annoucments/announcement.dart';
import 'package:accessify/screens/bottom_nav_screens/notifications.dart';
import 'package:accessify/screens/coupon/view_coupons.dart';
import 'package:accessify/screens/payments/my_payments.dart';
import 'package:accessify/screens/survey_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:accessify/data/img.dart';
import 'package:accessify/data/my_colors.dart';
import 'package:accessify/widget/my_text.dart';
import 'package:accessify/widget/toolbar.dart';

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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.fitHeight
                )
              ),
            ),
            Container(height: 8),
            InkWell(onTap: ()
            {Navigator.push(context, new MaterialPageRoute(
                builder: (context) => ViewCoupons()));

            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.label, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Coupons", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyPayments()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.monetization_on, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Payment", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
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
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => Announcements()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.speaker_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Announcements", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Survey()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.assignment_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Survey", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),

            Container(height: 10),
            InkWell(onTap: (){},
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.language, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Change Language", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: ()async{
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
