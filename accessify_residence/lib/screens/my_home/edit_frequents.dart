import 'dart:convert';
import 'dart:io';

import 'package:accessify/constants.dart';
import 'package:accessify/model/employee_model.dart';
import 'package:accessify/screens/home.dart';
import 'package:accessify/screens/my_home/frequent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:time_range_picker/time_range_picker.dart';
class EditFrequents extends StatefulWidget {
  EmployeeModel employee;

  EditFrequents(this.employee);

  @override
  _EditFrequentsState createState() => _EditFrequentsState();
}
class Days{
  bool ischecked;
  String Name;

  Days(this.ischecked, this.Name);

}

class _EditFrequentsState extends State<EditFrequents> {
  final _formKey = GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var vehicleController=TextEditingController();

  @override
  void initState() {
    setState(() {
      populateDaysList();
    });
    nameController.text=widget.employee.name;
    emailController.text=widget.employee.email;
    vehicleController.text=widget.employee.vehicle;
    setState(() {
      timeLimit=widget.employee.hoursAllowed;
      photoUrl=widget.employee.photo;
    });
    for(int i=0;i<_daysList.length;i++){
      for(int j=0;j<widget.employee.daysAllowed.length;j++){
        if(_daysList[i].Name==widget.employee.daysAllowed[j].toString()){
          setState(() {
            _daysList[i].ischecked=true;
          });
        }
      }
    }

  }


  String photoUrl;

  File _imageFile;

  List<Days> _daysList=[];

  populateDaysList(){
    Days day=new Days(false, "Monday");
    _daysList.add(day);
    day=new Days(false, "Tuesday");
    _daysList.add(day);
    day=new Days(false, "Wednesday");
    _daysList.add(day);
    day=new Days(false, "Thursday");
    _daysList.add(day);
    day=new Days(false, "Friday");
    _daysList.add(day);
    day=new Days(false, "Saturday");
    _daysList.add(day);
    day=new Days(false, "Sunday");
    _daysList.add(day);
    day=new Days(false, "Every Day");
    _daysList.add(day);
  }




  String startDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String endDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);


  final picker = ImagePicker();
  String timeLimit="Hours Allowed";

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadImageToFirebase(context);
  }
  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: 'Uploading Image',
    );
    pr.show();

    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(_imageFile);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        photoUrl = downloadUrl;
      });
    }
    pr.hide();
  }



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
                        Text('successful'.tr(),style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Text("Your frequent has been updated",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text('okay'.tr(),style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
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

  Future<void> _showchoiceDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          elevation: 2,

          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    pickImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Take Picture From Camera",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    pickImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Choose From Gallery",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),

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
                    child:Text('okay'.tr(),style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
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

  saveInfo(){
    List<String> dayNames=[];
    for(int i=0;i<_daysList.length;i++){
      if(_daysList[i].ischecked){
        dayNames.add(_daysList[i].Name);
      }
    }
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("home").doc("frequents").collection(user.uid).doc(widget.employee.id).update({
      'name': nameController.text,
      'email': emailController.text,
      'vehicle': vehicleController.text,
      'photo': photoUrl,
      'hoursAllowed':timeLimit,
      'fromDate':startDate,
      'expDate':endDate,
      'daysAllowed':dayNames

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
                                "Edit Frequents",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(
                                  "Your can edit frequents here",
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
                    'fillTheInformation'.tr(),
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
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'pleaseEnterSomeText'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.person_outline,color: Colors.black,size: 22,),
                            fillColor: Colors.grey[200],
                            hintText: 'enterName'.tr(),
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'pleaseEnterSomeText'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.email_outlined,color: Colors.black,size: 22,),
                            fillColor: Colors.grey[200],
                            hintText: "Enter Email",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: vehicleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'pleaseEnterSomeText'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.car_repair,color: Colors.black,size: 22,),
                            fillColor: Colors.grey[200],
                            hintText: "Enter Vehicle ID",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () =>_showchoiceDailog(),
                          child: Container(
                              padding: EdgeInsets.only(left:10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey[200],
                              ),
                              child:  photoUrl==null?Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.photo_outlined,color: Colors.black,size: 22,),
                                  ),

                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                        padding: EdgeInsets.only(left:12,top: 12,bottom: 12),
                                        child:Text("Add Photo",style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[700]
                                        ),),
                                      )
                                  )
                                ],
                              ):GestureDetector(
                                onTap: _showchoiceDailog,
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(photoUrl,width: double.maxFinite,height: 150,fit: BoxFit.cover,),
                                  ),
                                ),
                              )
                          ),
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
                        GestureDetector(
                          onTap: () async {
                            TimeRange result = await showTimeRangePicker(
                              context: context,
                            );
                            print("result ${result.startTime.hour}:${result.startTime.minute}   TO   ${result.endTime.hour}:${result.endTime.minute}");
                            setState(() {
                              timeLimit="${result.startTime.hour}:${result.startTime.minute}   TO   ${result.endTime.hour}:${result.endTime.minute}";
                            });
                          },
                          child: Container(
                            height: 50,
                              padding: EdgeInsets.only(left:10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey[200],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.timer_outlined,color: Colors.black,size: 22,),
                                  ),

                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                        padding: EdgeInsets.only(left:12),
                                        child:Text(timeLimit,style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[700]
                                        ),),
                                      )
                                  )
                                ],
                              )
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                            padding: EdgeInsets.only(left:10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[200],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              //scrollDirection: Axis.horizontal,
                              itemCount: _daysList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context,int index){
                                return CheckboxListTile(
                                    title: Text(_daysList[index].Name),
                                    value: _daysList[index].ischecked,
                                    activeColor: kPrimaryColor,
                                    onChanged: (bool value){
                                      if(_daysList[index].Name=="Every Day"){
                                        _daysList[7].ischecked=true;
                                        for(int i = 0;i<_daysList.length-1;i++){
                                          setState(() {
                                            _daysList[i].ischecked=false;
                                          });
                                        }

                                      }

                                      else{
                                        setState(() {
                                          _daysList[7].ischecked=false;
                                          _daysList[index].ischecked=value;
                                        });
                                      }
                                    }
                                );
                              },
                            )
                        ),


                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){

                            if (_formKey.currentState.validate()) {
                              saveInfo();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: Text("Update Frequents",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
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
