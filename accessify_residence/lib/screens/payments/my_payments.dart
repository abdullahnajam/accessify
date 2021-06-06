import 'package:accessify/model/payment_model.dart';
import 'package:accessify/payment/payment-service.dart';
import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  Future<List<PaymentModel>> getPending() async {
    List<PaymentModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    print(user.uid);
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("payment").child(user.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          PaymentModel paymentModel = new PaymentModel(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['prefix'],
            DATA[individualKey]['status'],
            DATA[individualKey]['amount'],
          );
          if(paymentModel.status=="pending"){
            list.add(paymentModel);
          }

        }
      }
    });
    return list;
  }
  Future<List<PaymentModel>> getToAuthorize() async {
    List<PaymentModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    print(user.uid);
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("payment").child(user.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          PaymentModel paymentModel = new PaymentModel(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['prefix'],
            DATA[individualKey]['status'],
            DATA[individualKey]['amount'],
          );
          if(paymentModel.status=="To Authorize"){
            list.add(paymentModel);
          }

        }
      }
    });
    return list;
  }
  Future<List<PaymentModel>> getAuthorized() async {
    List<PaymentModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    print(user.uid);
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("payment").child(user.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          PaymentModel paymentModel = new PaymentModel(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['prefix'],
            DATA[individualKey]['status'],
            DATA[individualKey]['amount'],
          );
          if(paymentModel.status=="Authorized"){
            list.add(paymentModel);
          }

        }
      }
    });
    return list;
  }

  payViaNewCard(BuildContext context,String id) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    
    var response = await StripeService.payWithNewCard(
        amount: '15000',
        currency: 'USD'
    ).whenComplete(() {
      User user=FirebaseAuth.instance.currentUser;
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child("payment").child(user.uid).child(id).update({
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
                            FutureBuilder<List<PaymentModel>>(
                              future: getPending(),
                              builder: (context,snapshot){
                                if (snapshot.hasData) {
                                  if (snapshot.data != null && snapshot.data.length>0) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      //scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,int index){
                                        return Padding(
                                            padding: const EdgeInsets.only(top: 15.0),
                                            child: InkWell(
                                              onTap: (){
                                                payViaNewCard(context,snapshot.data[index].id);
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
                                                                  Text(snapshot.data[index].title,style: TextStyle(fontSize: 15),),

                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                                  decoration: BoxDecoration(
                                                                      color: kPrimaryColor,

                                                                      borderRadius: BorderRadius.circular(3)
                                                                  ),
                                                                  child: Text(snapshot.data[index].status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Text("${snapshot.data[index].prefix}${snapshot.data[index].amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                        ),
                                                      ),)
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    return new Center(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 100),
                                          child: Text("You currently don't have any pending payments")
                                      ),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
                                  return Text('Error : ${snapshot.error}');
                                } else {
                                  return new Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            FutureBuilder<List<PaymentModel>>(
                              future: getToAuthorize(),
                              builder: (context,snapshot){
                                if (snapshot.hasData) {
                                  if (snapshot.data != null && snapshot.data.length>0) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      //scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,int index){
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
                                                                  Text(snapshot.data[index].title,style: TextStyle(fontSize: 15),),

                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                                  decoration: BoxDecoration(
                                                                      color: kPrimaryColor,

                                                                      borderRadius: BorderRadius.circular(3)
                                                                  ),
                                                                  child: Text(snapshot.data[index].status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Text("${snapshot.data[index].prefix}${snapshot.data[index].amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                        ),
                                                      ),)
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    return new Center(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 100),
                                          child: Text("You currently don't have any payments to be authorized")
                                      ),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
                                  return Text('Error : ${snapshot.error}');
                                } else {
                                  return new Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            FutureBuilder<List<PaymentModel>>(
                              future: getAuthorized(),
                              builder: (context,snapshot){
                                if (snapshot.hasData) {
                                  if (snapshot.data != null && snapshot.data.length>0) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      //scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,int index){
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
                                                                  Text(snapshot.data[index].title,style: TextStyle(fontSize: 15),),

                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                                  decoration: BoxDecoration(
                                                                      color: kPrimaryColor,

                                                                      borderRadius: BorderRadius.circular(3)
                                                                  ),
                                                                  child: Text(snapshot.data[index].status,style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Text("${snapshot.data[index].prefix}${snapshot.data[index].amount}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                                        ),
                                                      ),)
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    return new Center(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 100),
                                          child: Text("You currently don't have any authorized payments")
                                      ),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
                                  return Text('Error : ${snapshot.error}');
                                } else {
                                  return new Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
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
