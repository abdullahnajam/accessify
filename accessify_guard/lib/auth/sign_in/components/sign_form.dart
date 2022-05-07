import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guard/model/user_model.dart';
import 'package:guard/provider/UserDataProvider.dart';
import 'package:guard/screens/access_control/access_control.dart';
import 'package:guard/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:guard/components/custom_surfix_icon.dart';
import 'package:guard/components/form_error.dart';
import 'package:guard/helper/keyboard.dart';
import 'package:guard/auth/forgot_password/forgot_password_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: ()async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final ProgressDialog pr = ProgressDialog(context);
                pr.show();
                KeyboardUtil.hideKeyboard(context);
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password
                  ).whenComplete(() {
                    pr.hide();
                    FirebaseAuth.instance.authStateChanges().listen((User user) {
                      if (user == null) {

                        print('User is currently signed out!');
                      }
                      else {
                        print('User is signed in!');
                        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                        _firebaseMessaging.subscribeToTopic('guard');
                        _firebaseMessaging.getToken().then((token){
                          FirebaseFirestore.instance.collection("guard").doc(user.uid).update({
                            "token":token,
                          }).then((value)async{
                            await FirebaseFirestore.instance
                                .collection('guard')
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
                            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => AccessControl()));

                          }).onError((error, stackTrace) {
                            Toast.show("DB Error : ${errors.toString()}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                          });

                        }).onError((error, stackTrace) {
                          Toast.show("Token Error : ${errors.toString()}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                        });

                      }
                    });
                  });
                }
                on FirebaseAuthException catch (e) {
                  pr.hide();
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/Lock.png"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/Mail.png"),
      ),
    );
  }
}
