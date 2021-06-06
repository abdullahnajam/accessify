import 'package:accessify/constants.dart';
import 'package:accessify/model/access/delivery.dart';
import 'package:accessify/model/pet_model.dart';
import 'package:accessify/model/vehicle_model.dart';
import 'package:accessify/screens/access_control/delivery/create_delivery.dart';
import 'package:accessify/screens/my_home/create_pet.dart';
import 'package:accessify/screens/my_home/create_vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryAccess extends StatefulWidget {
  @override
  _DeliveryAccessState createState() => _DeliveryAccessState();
}

class _DeliveryAccessState extends State<DeliveryAccess> with SingleTickerProviderStateMixin{

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


  Future<List<Delivery>> getDeliveryList() async {
    List<Delivery> list=[];
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("delivery").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Delivery delivery = new Delivery(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['date'],
            DATA[individualKey]['hour'],
            DATA[individualKey]['status'],
              DATA[individualKey]['userId']
          );
          print("key ${delivery.id}");
          if(delivery.status=="scheduled" && user.uid==delivery.userId){
            list.add(delivery);
          }


        }
      }
    });
    return list;
  }

  Future<List<Delivery>> getDeliveryHistoryList() async {
    List<Delivery> list=[];
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("delivery").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Delivery delivery = new Delivery(
              individualKey,
              DATA[individualKey]['name'],
              DATA[individualKey]['date'],
              DATA[individualKey]['hour'],
              DATA[individualKey]['status'],
              DATA[individualKey]['userId']
          );
          print("key ${delivery.id}");
          if(delivery.status=="history" && user.uid==delivery.userId){
            list.add(delivery);
          }


        }
      }
    });
    return list;
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
                              "My deliveries",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add your deliveries here",
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
                        "Click To Explore",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => CreateDelivery()));
                        },
                      )
                    ],
                  )
              ),


              DefaultTabController(
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
                                child: FutureBuilder<List<Delivery>>(
                                  future: getDeliveryList(),
                                  builder: (context,snapshot){
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null && snapshot.data.length>0) {
                                        return ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          //scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Container(

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
                                                                Text(snapshot.data[index].name,style: TextStyle(fontWeight:FontWeight.w500,fontSize: 20,color: Colors.black),),

                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Container(
                                                                padding: EdgeInsets.only(top: 2,bottom: 2),

                                                                child: Text(snapshot.data[index].date,style: TextStyle(fontSize: 14,),)
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      child: Text(snapshot.data[index].hour,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300,)
                                                      ),
                                                    ),)
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      else {
                                        return new Center(
                                          child: Container(
                                              margin: EdgeInsets.only(top: 100),
                                              child: Text("You currently don't have any deliveries")
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
                                child: FutureBuilder<List<Delivery>>(
                                  future: getDeliveryHistoryList(),
                                  builder: (context,snapshot){
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null && snapshot.data.length>0) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          //scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Container(

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
                                                                Text(snapshot.data[index].name,style: TextStyle(fontWeight:FontWeight.w500,fontSize: 20,color: Colors.black),),

                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Container(
                                                                padding: EdgeInsets.only(top: 2,bottom: 2),

                                                                child: Text(snapshot.data[index].date,style: TextStyle(fontSize: 14,),)
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      child: Text(snapshot.data[index].hour,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300,)
                                                      ),
                                                    ),)
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      else {
                                        return new Center(
                                          child: Container(
                                              margin: EdgeInsets.only(top: 100),
                                              child: Text("You currently don't have any deliveries")
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
              ),
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
