import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:accessify/routes.dart';
import 'package:accessify/auth/splash.dart';
import 'package:accessify/theme.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        // home: SplashScreen(),
        // We use routeName so that we dont need to remember the name
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
