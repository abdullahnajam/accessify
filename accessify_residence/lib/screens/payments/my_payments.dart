import 'dart:io';

import 'package:accessify/model/payment_model.dart';
import 'package:accessify/payment/payment-service.dart';
import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../constants.dart';
class MyPayments extends StatefulWidget {
  @override
  _MyPaymentsState createState() => _MyPaymentsState();
}

class _MyPaymentsState extends State<MyPayments> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    StripeService.init();

  }
  String photoUrl;
  File _imageFile;
  final picker = ImagePicker();

  Future<void> _showchoiceDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.7),
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
                Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: 40,
                  margin: EdgeInsets.only(left: 40,right: 40),
                  child:Text("Send Receipt",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w700),),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
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
  String selectedId="";
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
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: 'Uploading Image',
    );
    pr.show();
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage.ref().child('bookingPics/${DateTime.now().millisecondsSinceEpoch}').putFile(_imageFile);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        photoUrl = downloadUrl;
      });
      final f = new DateFormat('dd-MM-yyyy');
      FirebaseFirestore.instance.collection('payment').doc(selectedId).update({
        'status': "To Authorize",
        'proofUrl': photoUrl,
        'submissionDate': f.format(DateTime.now()).toString(),
        'submissionInMilli': DateTime.now().millisecondsSinceEpoch,
      });
    }
    pr.hide();
  }

  payViaNewCard(BuildContext context,String id) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    
    await StripeService.payWithNewCard(
        amount: '15000',
        currency: 'USD'
    ).then((value) {
      FirebaseFirestore.instance.collection("payment").doc(id).update({
        'status': "To Authorize",
        
      }).then((value) => Navigator.pushReplacement(context, new MaterialPageRoute(
          builder: (context) => MyPayments())));
    });
    await dialog.hide();

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.08,

              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("My Name",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: kPrimaryColor),),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              )
            ),

            DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kPrimaryColor)
                        ),


                        child: TabBar(
                          labelStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),
                          indicatorColor: kPrimaryColor,

                          indicator: UnderlineTabIndicator(

                            borderSide: BorderSide(width: 0.0,color: Colors.transparent),
                          ),
                          labelColor: Colors.white,
                          indicatorPadding: EdgeInsets.all(0),
                          labelPadding: EdgeInsets.all(0),
                          unselectedLabelStyle:TextStyle(fontSize: 15,fontWeight: FontWeight.w400),
                          unselectedLabelColor: Color(0xffabc6ff),
                          tabs: [
                            Tab(text: 'Pending'),
                            Tab(text: 'To Authorize'),
                            Tab(text: 'Authorized'),
                          ],
                        ),
                      ),
                      Container(
                          //height of TabBarView
                          height: MediaQuery.of(context).size.height*0.8,

                          child: TabBarView(children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('payment')
                                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).where('status',isEqualTo: "Pending").snapshots(),
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
                                  PaymentModel model=PaymentModel.fromMap(data, document.reference.id);
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedId=model.id;
                                          });
                                          _showchoiceDailog();
                                        },
                                        child: Container(

                                          height: 70,
                                          margin:EdgeInsets.only(left: 20,right: 20,top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius:1,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        Row(
                                                          children: [
                                                            Text(model.concept,style: TextStyle(fontSize: 15),),

                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                            padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                            decoration: BoxDecoration(
                                                                color: kPrimaryColor,

                                                                borderRadius: BorderRadius.circular(3)
                                                            ),
                                                            child: Text(model.status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Text("\$${model.amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                  ),
                                                ),)
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                }).toList(),
                              );
                            },
                          ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('payment')
                                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                                  .where('status',isEqualTo: "To Authorize").snapshots(),
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
                                    PaymentModel model=PaymentModel.fromMap(data, document.reference.id);
                                    return Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: InkWell(
                                          child: Container(
                                            height: 70,
                                            margin:EdgeInsets.only(left: 20,right: 20,top: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius:1,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 1), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [

                                                          Row(
                                                            children: [
                                                              Text(model.concept,style: TextStyle(fontSize: 15),),

                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Container(
                                                              padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                              decoration: BoxDecoration(
                                                                  color: kPrimaryColor,

                                                                  borderRadius: BorderRadius.circular(3)
                                                              ),
                                                              child: Text(model.status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Text("\$${model.amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                    ),
                                                  ),)
                                              ],
                                            ),
                                          ),
                                        )
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('payment').where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).where('status',isEqualTo: "Authorized").snapshots(),
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
                                    PaymentModel model=PaymentModel.fromMap(data, document.reference.id);
                                    return Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: InkWell(

                                          child: Container(

                                            height: 70,
                                            margin:EdgeInsets.only(left: 20,right: 20,top: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius:1,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 1), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [

                                                          Row(
                                                            children: [
                                                              Text(model.concept,style: TextStyle(fontSize: 15),),

                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Container(
                                                              padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                              decoration: BoxDecoration(
                                                                  color: kPrimaryColor,

                                                                  borderRadius: BorderRadius.circular(3)
                                                              ),
                                                              child: Text(model.status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Text("\$${model.amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                    ),
                                                  ),)
                                              ],
                                            ),
                                          ),
                                        )
                                    );
                                  }).toList(),
                                );
                              },
                            ),



                            


                          ])
                      )

                    ])
            ),
          ]),
        ),
      ),
    );
  }
}
