import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              height: MediaQuery.of(context).size.height*0.35,

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
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Icon(Icons.add,color: Colors.white,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: kPrimaryColor
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  CreditCard(
                    cardNumber: "0000 0000 0000 0000",
                    cardExpiry: "12/12/21",
                    cardHolderName: "my name",
                    cvv: "123",
                    bankName: "My Bank",
                    showBackSide: false,
                    frontBackground: CardBackgrounds.black,
                    backBackground: CardBackgrounds.white,
                    showShadow: true,
                  ),
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
                          height: MediaQuery.of(context).size.height*0.45,

                          child: TabBarView(children: <Widget>[
                            Container(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Container(

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
                                                    Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                    SizedBox(width: 15,),
                                                    Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                    padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                    decoration: BoxDecoration(
                                                        color: kPrimaryColor,

                                                        borderRadius: BorderRadius.circular(3)
                                                    ),
                                                    child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                )
                                              ],
                                            ),
                                          )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                  Container(

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
                                                      Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 15,),
                                                      Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                      padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,

                                                          borderRadius: BorderRadius.circular(3)
                                                      ),
                                                      child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                            ),
                                          ),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Container(

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
                                                      Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 15,),
                                                      Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                      padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,

                                                          borderRadius: BorderRadius.circular(3)
                                                      ),
                                                      child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                            ),
                                          ),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Container(

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
                                                      Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 15,),
                                                      Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                      padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,

                                                          borderRadius: BorderRadius.circular(3)
                                                      ),
                                                      child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                            ),
                                          ),)
                                      ],
                                    ),
                                  ),
                                  Container(

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
                                                      Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 15,),
                                                      Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                      padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,

                                                          borderRadius: BorderRadius.circular(3)
                                                      ),
                                                      child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                            ),
                                          ),)
                                      ],
                                    ),
                                  ),
                                  Container(

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
                                                      Text("MAR - 2021",style: TextStyle(fontSize: 15),),
                                                      SizedBox(width: 15,),
                                                      Text("No. 0001",style: TextStyle(fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                      padding: EdgeInsets.only(top: 2,bottom: 2,left: 10,right: 10),
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,

                                                          borderRadius: BorderRadius.circular(3)
                                                      ),
                                                      child: Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,),)
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text("\$100",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700,)
                                            ),
                                          ),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
