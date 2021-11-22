import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:accessify/size_config.dart';

const kPrimaryColor = Colors.blue;
const bgColor=Color(0xffeeeeee);
const serverToken="AAAAO-nylpM:APA91bEoAIIpHaWsJJL_wogtFDG4yZKe_ahcFfVWOVW_ODdBcqayZq4ixa0k4-A6KPghn9ICwC8o3gWv7R0QyM4mZT_18vXdMlMwlXgPoSiSSJEZhsp7JVfHZl0QpLlCUsaLZ3cDymPz";
const kPrimaryLightColor = Color(0xFF648ee4);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFd1e0ff), Color(0xFF9dbcfa)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

//shared preference values
const String allowedVisits="allowedVisits";

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
