import 'package:accessify/auth/sign_in/sign_in_screen.dart';
import 'package:accessify/constants.dart';
import 'package:accessify/navigator/bottom_navigation.dart';
import 'package:accessify/screens/access_control/main_screen.dart';
import 'package:accessify/screens/annoucments/announcement.dart';
import 'package:accessify/screens/bottom_nav_screens/notifications.dart';
import 'package:accessify/screens/coupon/view_coupons.dart';
import 'package:accessify/screens/home.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/payments/my_payments.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:accessify/screens/survey_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
  _showChangeLanguageDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('changeLanguage'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('es', 'MX');
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text("Español"),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text("English"),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('changePassword'.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text('message'.tr()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain
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
                    Expanded(child: Text('coupons'.tr(), )),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyHome()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('myHome'.tr(), )),
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
                    Expanded(child: Text('accessControl'.tr(), )),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ViewReservations()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today_outlined, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('reservation'.tr(), )),
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
                    Expanded(child: Text('payment'.tr(), )),
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
                    Expanded(child: Text('survey'.tr(), )),
                  ],
                ),
              ),
            ),

            Container(height: 10),
            InkWell(onTap: (){
              _showChangeLanguageDailog();
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.language, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('changeLanguage'.tr(), )),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(
              onTap: ()async{
                final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                await firebaseAuth.sendPasswordResetEmail(email: firebaseAuth.currentUser.email).whenComplete((){
                  _showPasswordDialog();
                }).catchError((onError){
                  print(onError.toString());
                  final snackBar = SnackBar(content: Text(onError.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                });

              },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.password, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('forgotPassword'.tr(), )),
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
                    Expanded(child: Text('logout'.tr(), )),
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
