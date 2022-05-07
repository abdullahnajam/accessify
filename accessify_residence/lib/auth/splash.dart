import 'dart:async';
import 'package:accessify/auth/sign_in/sign_in_screen.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/navigator/bottom_navigation.dart';
import 'package:accessify/provider/UserDataProvider.dart';
import 'package:accessify/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
    User user=FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is currently signed out!');
      Navigator.pushNamed(context, SignInScreen.routeName);
    }
    else {
      print('User is signed in!');

      await FirebaseFirestore.instance
          .collection('homeowner')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {

          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          UserModel userModel=UserModel.fromMap(data, documentSnapshot.reference.id);
          final provider = Provider.of<UserDataProvider>(context, listen: false);
          provider.setUserData(userModel);

        }
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));

    }


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

