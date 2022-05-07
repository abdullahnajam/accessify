import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guard/provider/UserDataProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'auth/splash.dart';
import 'theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(),
        ),

      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Accesfy Guard',
          theme: theme(),
          // home: SplashScreen(),
          // We use routeName so that we dont need to remember the name
          initialRoute: SplashScreen.routeName,
          routes: routes,
        ),
      ),
    );
  }
}
