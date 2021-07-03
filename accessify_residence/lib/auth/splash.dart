import 'dart:async';
import 'package:accessify/auth/sign_in/sign_in_screen.dart';
import 'package:accessify/navigator/bottom_navigation.dart';
import 'package:accessify/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;


  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushNamed(context, SignInScreen.routeName);
      }
      else {
        print('User is signed in!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));

      }
    });


  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Image.asset('assets/images/logo.png'),
              )

            ],
          )),

      ),
    );
  }
}

