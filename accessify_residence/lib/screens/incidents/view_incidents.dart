import 'package:accessify/model/incident_model.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/screens/incidents/create_incident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants.dart';
class ViewIncidents extends StatefulWidget {
  @override
  _ViewIncidentsState createState() => _ViewIncidentsState();
}

class _ViewIncidentsState extends State<ViewIncidents> {
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: isLoading?Container(
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
                              "Reports",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add incidents, complains and suggestions here",
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
                        "Incident - Suggestion - Complain",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0),
                      ),
                      IconButton(icon: Icon(Icons.add), onPressed:() {
                      Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => CreateIncident()));
                      })
                    ],
                  )
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reports').
                where("neighbourId",isEqualTo: userModel.neighbourId).snapshots(),
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
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      IncidentModel model=new IncidentModel(
                        document.reference.id,
                        data['title'],
                        data['description'],
                        data['photo'],
                        data['time'],
                        data['type'],
                        data['userId'],
                        data['status'],
                        data['classification'],
                      );
                      return new Padding(
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
                                    height: 120,
                                    decoration: BoxDecoration(
                                        image:  DecorationImage(
                                          image: NetworkImage(model.photo),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:  Radius.circular(10))
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(model.title,style: TextStyle(fontSize:18,fontWeight: FontWeight.w700,color: Colors.black),),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(model.description,style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
                                            Container(
                                              padding: EdgeInsets.all(3),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: kPrimaryColor),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Text(model.type,textAlign: TextAlign.center,style: TextStyle(fontSize:13,fontWeight: FontWeight.w300,color: kPrimaryLightColor),),
                                            ),

                                          ],
                                        ),

                                        Divider(color: Colors.grey,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.place,color: Colors.white,size: 16,),
                                                Text(model.status,style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time,color: Colors.grey,size: 16,),
                                                Text(timeAgoSinceDate(model.time),style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
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



            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}

