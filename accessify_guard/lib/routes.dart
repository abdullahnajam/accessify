import 'auth/forgot_password/forgot_password_screen.dart';
import 'auth/sign_in/sign_in_screen.dart';
import 'auth/splash.dart';
import 'screens/home.dart';
import 'package:flutter/widgets.dart';

import 'auth/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  Home.routeName: (context) => Home(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
