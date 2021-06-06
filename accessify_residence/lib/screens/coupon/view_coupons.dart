import 'package:accessify/model/coupon_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class ViewCoupons extends StatefulWidget {
  @override
  _ViewCouponsState createState() => _ViewCouponsState();
}

class _ViewCouponsState extends State<ViewCoupons> {
  Future<List<CouponModel>> getEmpList() async {
    List<CouponModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("coupons").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          CouponModel incidentModel = new CouponModel(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['description'],
            DATA[individualKey]['logo'],
            DATA[individualKey]['photo'],
            DATA[individualKey]['expiration']
          );
          print("key ${incidentModel.id}");
          list.add(incidentModel);

        }
      }
    });
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: double.maxFinite,
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
                              "Coupons",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view available coupons here",
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
                  const EdgeInsets.only(right:10,left: 15.0, top: 40.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coupons",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                      /*IconButton(icon: Icon(Icons.add), onPressed:() {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => CreateIncident()));
                      })*/
                    ],
                  )
              ),

              FutureBuilder<List<CouponModel>>(
                future: getEmpList(),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.length>0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                          return Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius:1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  image:  DecorationImage(
                                                    image: NetworkImage(snapshot.data[index].logo),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(snapshot.data[index].title,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                                                  Text(snapshot.data[index].expiration)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(snapshot.data[index].description),
                                      ),
                                      Container(
                                        height: 150,

                                        decoration: BoxDecoration(
                                            image:  DecorationImage(
                                              image: NetworkImage(snapshot.data[index].photo),
                                              fit: BoxFit.cover,
                                            ),
                                            //borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:  Radius.circular(10))
                                        ),
                                      ),

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
                            child: Text("You currently don't have any employees")
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
              SizedBox(
                height: 20.0,
              )

            ],
          ),
        ),
      ),
    );
  }
}
