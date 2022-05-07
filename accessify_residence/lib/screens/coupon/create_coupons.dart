import 'dart:io';

import 'package:accessify/constants.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/screens/coupon/view_coupons.dart';
import 'package:accessify/screens/home.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
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
import 'package:toast/toast.dart';
class CreateCoupon extends StatefulWidget {
  @override
  _CreateCouponState createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  final _formKey = GlobalKey<FormState>();
  var nameController=TextEditingController();
  var desController=TextEditingController();
  var priceController=TextEditingController();
  var dateController=TextEditingController();
  var phoneController=TextEditingController();
  String startDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String photoUrl,classification;

  File _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

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
                    Navigator.pop(context);
                    pickImageFromGallery();
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

  UserModel userModel;
  bool isLoading=false;

  getUserData()async{
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('homeowner')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        userModel=UserModel.fromMap(data, documentSnapshot.reference.id);
        setState(() {
          isLoading=true;
        });
      }
    });

  }


  @override
  void initState() {
    getUserData();
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;

    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(_imageFile);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        photoUrl = downloadUrl;
        print("photo url $photoUrl");
      });
    }
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
                        Text("Your coupon has been added",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (BuildContext context) => ViewCoupons()));
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

  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  saveInfo(){
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('homeowner')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        FirebaseFirestore.instance.collection("coupons").add({
          'title': nameController.text,
          'description': desController.text,
          'time': DateTime.now().toString(),
          'image': photoUrl,
          'status':"Pending",
          'userId':user.uid,
          'username': "${data['firstName']}${data['lastName']}",
          'classification':classification,
          'phone':phoneController.text,
          'price':priceController.text,
          'expiration':startDate,
          'neighbourId': userModel.neighbourId,
        }).then((value) {
          _showSuccessDailog();
        })
            .catchError((error, stackTrace) {
          print("inner: $error");
          // although `throw SecondError()` has the same effect.
          _showFailuresDailog(error.toString());
        });
      }
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
                                "Add Coupon",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(
                                  "Your can add new coupons here",
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
                            fillColor: Colors.grey[200],
                            hintText: "Enter Title",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          controller: desController,
                          maxLines: 3,
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
                            fillColor: Colors.grey[200],
                            hintText: 'enterDescription'.tr(),
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
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
                            fillColor: Colors.grey[200],
                            hintText: "Enter Price",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),


                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
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
                            fillColor: Colors.grey[200],
                            hintText: "Enter Phone Number",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
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
                            fillColor: Colors.grey[200],
                            hintText: startDate,
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('classification_marketplace').
                            where("neighbourId",isEqualTo: userModel.neighbourId).snapshots(),
                            builder: (context, snapshot){
                              if (!snapshot.hasData)
                                return const Center(child: const CircularProgressIndicator(),);
                              var length = snapshot.data.docs.length;
                              DocumentSnapshot ds = snapshot.data.docs[length - 1];
                              Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                              return new Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.grey[200]
                                ),
                                child: new DropdownButton<String>(
                                  underline: Container(),
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.black),
                                  value: classification!=null?classification:data['name'],
                                  onChanged: (String newValue) {
                                    setState(() {
                                      classification = newValue;
                                      print(classification);
                                    });
                                  },
                                  items: snapshot.data.docs.map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                    return DropdownMenuItem<String>(
                                        value: data['name'],
                                        child: Text(data['name'])
                                    );
                                  }).toList(),
                                ),
                              );
                            }
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
                              child:  _imageFile==null?Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(Icons.photo_outlined,color: Colors.black,size: 22,),
                                    ),

                                    Expanded(
                                        flex: 9,
                                        child: Container(
                                          padding: EdgeInsets.only(left:12),
                                          child:Text("Add Photo",style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey[700]
                                          ),),
                                        )
                                    )
                                  ],
                                ),
                              ):GestureDetector(
                                onTap: _showchoiceDailog,
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(_imageFile,width: double.maxFinite,height: 150,fit: BoxFit.cover,),
                                  ),
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){
                            //print(timeAgoSinceDate('2021-04-25 23:35:09.911320'));
                            //print(DateTime.now().toString());
                            if (_formKey.currentState.validate()) {
                              if(photoUrl!=null)
                                saveInfo();
                              else
                                Toast.show("Please select an image", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: Text("Add Coupon",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
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
