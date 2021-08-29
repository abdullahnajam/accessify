import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:accessify/constants.dart';
import 'package:accessify/model/access/employee_frequent_model.dart';
import 'package:accessify/model/employee_model.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
class EditEmployeeFrequent extends StatefulWidget {
  EmployeeAccessModel model;
  EditEmployeeFrequent(this.model);
  @override
  _EditEmployeeFrequentState createState() => _EditEmployeeFrequentState();
}
enum access { employee, frequent }

class _EditEmployeeFrequentState extends State<EditEmployeeFrequent> {
  final _formKey = GlobalKey<FormState>();
  access _access = access.employee;
  bool employee=true;
  bool frequent=false;

  String time=formatDate(DateTime.now(), [hh, ':', nn]);
  String startDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String endDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);



  @override
  void initState() {

    setState(() {
      nameText=widget.model.emp;
      widget.model.type=="Employee"?employee=true:employee=false;
      startDate=widget.model.fromDate;
      endDate=widget.model.expDate;
    });
  }



  EmployeeModel emp;
  String nameText="Add Employee";








  Future<void> _showSuccessDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/json/success.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: Column(
                      children: [
                        Text("Successful",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Text("Your employee/frequent has been updated",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("OKAY",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
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

  Future<void> _showEmpDailog() async {
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
                  child: Text("Employees",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('home').doc('employees').collection(FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                            Text("No Employees")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        EmployeeModel model=new EmployeeModel(
                          document.reference.id,
                          data['name'],
                          data['email'],
                          data['fromDate'],
                          data['expDate'],
                          data['vehicle'],
                          data['photo'],
                          data['hoursAllowed'],
                          data['daysAllowed'],
                        );
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              nameText=model.name;
                              emp=model;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(model.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
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
  Future<void> _showFreqDailog() async {
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
                  child: Text("Frequents",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('home').doc('frequents').collection(FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                            Text("No Frequents")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        EmployeeModel model=new EmployeeModel(
                          document.reference.id,
                          data['name'],
                          data['email'],
                          data['fromDate'],
                          data['expDate'],
                          data['vehicle'],
                          data['photo'],
                          data['hoursAllowed'],
                          data['daysAllowed'],
                        );
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              nameText=model.name;
                              emp=model;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(model.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
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



  Future<void> _showFailuresDailog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/json/error.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: Column(
                      children: [
                        Text("Error",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Text(error,textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("OKAY",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
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

  saveInfo() async{
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("employee_access").doc(widget.model.id).update({
      'emp': nameText,
      'fromDate':startDate,
      'expDate':time,
      'userId':user.uid,
      'qr':widget.model.qr,
      'type':employee?"Employee":"Frequent",
    }).then((value) {
      _showSuccessDailog();
    })
        .catchError((error, stackTrace) {
      print("inner: $error");
      // although `throw SecondError()` has the same effect.
      _showFailuresDailog(error.toString());
    });




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[

                    Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0))
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 75.0),
                      child: Center(
                        child: Container(
                          height: 120.0,
                          width: 310.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(color: Colors.black12.withOpacity(0.1)),
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Add employee/frequent",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(
                                  "Your can add new employee/frequent here",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16.0),
                                ),
                                padding: EdgeInsets.only(left: 20,right: 20),
                              )

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 25.0, top: 40.0, bottom: 10.0),
                  child: Text(
                    "Fill the Information",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Radio(
                              value: access.employee,
                              groupValue: _access,
                              onChanged: (access value) {
                                setState(() {
                                  nameText="Add Employee";
                                  employee = true;
                                  frequent = false;
                                  _access = value;
                                });
                              },
                            ),
                            new Text(
                              'Employee',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            new Radio(
                              value: access.frequent,
                              groupValue: _access,
                              onChanged: (access value) {
                                setState(() {
                                  nameText="Add Frequent";
                                  frequent = true;
                                  employee=false;
                                  _access = value;
                                });
                              },
                            ),
                            new Text(
                              'Frequent',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                            height: 50,
                            padding: EdgeInsets.only(left:10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child:FlatButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(2021, 1, 1),
                                            maxTime: DateTime(2025, 1, 1),
                                            onChanged: (date) {
                                              print('change $date');
                                            },
                                            onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                startDate = formatDate(date, [dd, '-', mm, '-', yyyy]);
                                              });
                                            },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      child: Text(
                                        startDate,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      )
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:Container(child: Text("TO"),alignment: Alignment.center,),
                                ),

                                Expanded(
                                  flex: 5,
                                  child: FlatButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(2021, 1, 1),
                                            maxTime: DateTime(2025, 1, 1),
                                            onChanged: (date) {
                                              print('change $date');
                                            },
                                            onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                endDate = formatDate(
                                                    date, [dd, '-', mm, '-', yyyy]);
                                              });
                                            },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      child: Text(
                                        endDate,
                                        style: TextStyle(color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      )
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 20),

                        Container(
                            padding: EdgeInsets.only(top:15,bottom:15,left:10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.people_outline,color: Colors.black,size: 22,),
                                ),

                                Expanded(
                                    flex: 9,
                                    child: Container(
                                      padding: EdgeInsets.only(left:12),
                                      child:InkWell(
                                          onTap: (){
                                            if(employee){
                                              _showEmpDailog();
                                            }
                                            else{
                                              _showFreqDailog();
                                            }
                                          },
                                          child:Text(nameText)
                                      ),
                                    )
                                )
                              ],
                            )
                        ),



                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){

                            if (_formKey.currentState.validate()) {
                              //_captureAndSharePng();
                              //saveInfo();
                              if(emp!=null)
                                saveInfo();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: Text("Update Employee/Frequent",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30)
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),

                /*RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: key,
                    size: 200,

                  ),
                ),*/


                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
