import 'package:accessify/model/user_model.dart';
import 'package:accessify/navigator/bottom_navigation.dart';
import 'package:accessify/provider/UserDataProvider.dart';
import 'package:accessify/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:accessify/components/custom_surfix_icon.dart';
import 'package:accessify/components/default_button.dart';
import 'package:accessify/components/form_error.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../../constants.dart';
import '../../../size_config.dart';



class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _neighbourId="";
  Future<void> _showNeighbourDialog() async {
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
                  child: Text("Neighbourhood",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('neighbours').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                            Text("Something Went Wrong")

                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.size==0){
                      return Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                            Text('noDataFound'.tr(),)

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                        return ListTile(
                          onTap: (){
                            setState(() {
                              neighbourController.text=data['name'];
                              _neighbourId=document.reference.id;
                            });
                            Navigator.pop(context);
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(data['logo'],),
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                          ),
                          //leading: Image.network(model.image),
                          title: Text(data['name'],textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),
                          ),
                        );
                      }).toList(),
                    );
                  },
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
  final _formKey = GlobalKey<FormState>();

  String email;
  String name;
  String password;
  String conform_password;
  var firstNameController=TextEditingController();
  var lastNameController=TextEditingController();
  var phoneController=TextEditingController();
  var neighbourController=TextEditingController();
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

          TextFormField(
            controller: firstNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_outline),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            controller: lastNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_outline),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),

          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            onTap: (){
              _showNeighbourDialog();
            },
            readOnly: true,
            controller: neighbourController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Neighbourhood",
              hintText: "Enter your neighbourhood",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.home_outlined),
            ),
          ),

          /*SizedBox(height: getProportionateScreenHeight(30)),

          buildConformPassFormField(),*/
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async{
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final ProgressDialog pr = ProgressDialog(context);
                pr.show();
                try {

                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password
                  ).whenComplete(() {
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User user) {
                      if (user == null) {
                        print('User is currently signed out!');
                      } else {
                        print('User is signed in!');
                        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                        _firebaseMessaging.subscribeToTopic('resident');
                        _firebaseMessaging.getToken().then((token) {
                          print(token);
                          User user=FirebaseAuth.instance.currentUser;
                          FirebaseFirestore.instance.collection('homeowner').doc(user.uid).set({
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'street': "not specified",
                            'building':  "not specified",
                            'floor':  "not specified",
                            'apartmentUnit':  "not specified",
                            'additionalAddress':  "not specified",
                            'phone': phoneController.text,
                            'cellPhone': phoneController.text,
                            'comment': "no comments",
                            'email': email,
                            'password': password,
                            'neighbourId':_neighbourId,
                            'neighbourhood':neighbourController.text,
                            'status':"Active",
                            'classification':"No Classification"
                          }).then((value) async{
                            UserModel userModel;
                            User user=FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance
                                .collection('homeowner')
                                .doc(user.uid)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {

                                Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                userModel=UserModel.fromMap(data, documentSnapshot.reference.id);
                                final provider = Provider.of<UserDataProvider>(context, listen: false);
                                provider.setUserData(userModel);
                              }
                            });
                            pr.hide();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
                          });

                        });
                      }
                    });
                  });
                } on FirebaseAuthException catch (e) {
                  pr.hide();
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    Toast.show("The password provided is too weak", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                  } else if (e.code == 'email-already-in-use') {
                    Toast.show("email-already-in-use", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                  }
                } catch (e) {
                  pr.hide();
                  Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                }

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/Lock.png"),
      ),
    );
  }
  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/Mail.png"),
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
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
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
