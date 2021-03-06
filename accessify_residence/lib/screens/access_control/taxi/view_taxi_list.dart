import 'package:accessify/constants.dart';
import 'package:accessify/model/access/delivery.dart';
import 'package:accessify/model/access/taxi_model.dart';
import 'package:accessify/model/pet_model.dart';
import 'package:accessify/model/vehicle_model.dart';
import 'package:accessify/screens/access_control/delivery/create_delivery.dart';
import 'package:accessify/screens/access_control/taxi/create_taxi.dart';
import 'package:accessify/screens/access_control/taxi/edit_taxi.dart';
import 'package:accessify/screens/my_home/create_pet.dart';
import 'package:accessify/screens/my_home/create_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';


class TaxiAccess extends StatefulWidget {
  @override
  _TaxiAccessState createState() => _TaxiAccessState();
}

class _TaxiAccessState extends State<TaxiAccess> with SingleTickerProviderStateMixin{

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

  Future<void> _showInfoDailog(TaxiModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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
                GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.only(right: 10,top: 10),
                    child: Icon(Icons.close),
                    alignment: Alignment.centerRight,
                  ),
                ),
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Taxi Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.description}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                        SizedBox(height: 10,),
                        Text("Start Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Start Hour",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.hour}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: ()async{
                                  User user=FirebaseAuth.instance.currentUser;
                                  FirebaseFirestore.instance.collection("taxi_access").doc(model.id).delete().then((value) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TaxiAccess()));
                                  });
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.22,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kPrimaryColor),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_forever_outlined,color: kPrimaryColor,),
                                      Text("Delete",style: TextStyle(color: kPrimaryColor),)
                                    ],
                                  ),

                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditTaxi(model)));
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.22,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      border: Border.all(color: kPrimaryColor),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit_outlined,color: Colors.white,),
                                      Text("Edit",style: TextStyle(color: Colors.white),)
                                    ],
                                  ),

                                ),
                              )

                            ],
                          ),
                        ),




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
                    child:Text("CLOSE",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
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






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                              'myTaxi'.tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add your taxi here",
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'clickToExplore'.tr(),
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => CreateTaxi()));
                        },
                      )
                    ],
                  )
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('taxi_access').where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                      TaxiModel model=new TaxiModel(
                        document.reference.id,
                        data['name'],
                        data['date'],
                        data['hour'],
                        data['status'],
                        data['userId'],
                        data['description'],
                        data['omw'],
                        data['pickup'],
                      );
                      return InkWell(
                        onTap: (){
                          _showInfoDailog(model);
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                child:  Icon(
                                  Icons.local_taxi,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              title: Text("${model.name}"),
                              subtitle: Text(model.date),
                              trailing: Text(model.hour),
                            ),
                          ),
                          secondaryActions: <Widget>[

                            IconSlideAction(
                              caption: 'edit'.tr(),
                              color: Colors.indigo,
                              icon: Icons.edit_outlined,
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EditTaxi(model))),
                            ),
                            IconSlideAction(
                              caption: 'delete'.tr(),
                              color: Colors.indigo,
                              icon: Icons.delete_forever_outlined,
                              onTap: () async{
                                User user=FirebaseAuth.instance.currentUser;
                                FirebaseFirestore.instance.collection("taxi_access").doc(model.id).delete().then((value) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TaxiAccess()));
                                });
                              },
                            ),
                          ],

                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              

              /*DefaultTabController(
                  length: 2, // length of tabs
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
                              Tab(text: 'Scheduled'),
                              Tab(text: 'History')
                            ],
                          ),
                        ),
                        Container(
                          //height of TabBarView
                            height:double.maxFinite,

                            child: TabBarView(children: <Widget>[
                              Container(
                                child: FutureBuilder<List<TaxiModel>>(
                                  future: getTaxiList(),
                                  builder: (context,snapshot){
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null && snapshot.data.length>0) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          //scrollDirection: Axis.horizontal,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return InkWell(
                                              onTap: (){
                                                _showInfoDailog(model);
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
                                                                  Text(model.name,style: TextStyle(fontWeight:FontWeight.w500,fontSize: 20,color: Colors.black),),

                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 2,bottom: 2),

                                                                  child: Text(model.date,style: TextStyle(fontSize: 14,),)
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Text(model.hour,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300,)
                                                        ),
                                                      ),)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      else {
                                        return new Center(
                                          child: Container(
                                              margin: EdgeInsets.only(top: 100),
                                              child: Text("You currently don't have any taxi")
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
                              ),
                              Container(
                                child: FutureBuilder<List<TaxiModel>>(
                                  future: getTaxiHistoryList(),
                                  builder: (context,snapshot){
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null && snapshot.data.length>0) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          //scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return InkWell(
                                              onTap: (){
                                                _showInfoDailog(model);
                                              },
                                              child:  Container(

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
                                                                  Text(model.name,style: TextStyle(fontWeight:FontWeight.w500,fontSize: 20,color: Colors.black),),

                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Container(
                                                                  padding: EdgeInsets.only(top: 2,bottom: 2),

                                                                  child: Text(model.date,style: TextStyle(fontSize: 14,),)
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Text(model.hour,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300,)
                                                        ),
                                                      ),)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      else {
                                        return new Center(
                                          child: Container(
                                              margin: EdgeInsets.only(top: 100),
                                              child: Text("You currently don't have any taxi")
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
                              ),

                            ])
                        )

                      ])
              ),*/
              SizedBox(
                height: 20.0,
              ),

            ],
          ),
        ),
      ),
    );
  }

}
