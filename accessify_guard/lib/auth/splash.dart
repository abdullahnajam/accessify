import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guard/auth/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/user_model.dart';
import 'package:guard/navigator/bottom_navigation.dart';
import 'package:guard/provider/UserDataProvider.dart';
import 'package:guard/screens/home.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

  void navigationPage() async{
    Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (context) => BottomBar()));

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png',height: height*0.5,width: width*0.7,),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Lottie.asset(
                    'assets/json/splash_loading.json',
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),


            ],
          )

      ),
    );
  }
}

