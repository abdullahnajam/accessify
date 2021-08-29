import 'package:accessify/model/coupon_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class ViewMyCoupons extends StatefulWidget {
  @override
  _ViewMyCouponsState createState() => _ViewMyCouponsState();
}

class _ViewMyCouponsState extends State<ViewMyCoupons> {

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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('coupons').where("userId",isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                          Text("No Coupons Added")

                        ],
                      ),
                    );

                  }

                  return new ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      CouponsModel model=CouponsModel.fromMap(data, document.reference.id);
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
                                          width: MediaQuery.of(context).size.width*0.2,
                                          height: MediaQuery.of(context).size.height*0.1,
                                          decoration: BoxDecoration(
                                              image:  DecorationImage(
                                                image: NetworkImage(model.image),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(model.title.toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                                              SizedBox(height: 5,),
                                              Text("\$${model.price}"),
                                              SizedBox(height: 5,),
                                              Text("${model.phone}"),
                                              SizedBox(height: 5,),
                                              Text("${model.status}"),
                                              SizedBox(height: 5,),
                                              Text(model.description)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: kPrimaryLightColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)
                                          )
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(model.expiration,style: TextStyle(color: Colors.white),),
                                          Text(model.classification,style: TextStyle(color: Colors.white),),
                                        ],
                                      )
                                  ),


                                ],
                              ),
                            ),
                          )
                      );
                    }).toList(),
                  );
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
