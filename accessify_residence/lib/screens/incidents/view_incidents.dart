import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class ViewIncidents extends StatefulWidget {
  @override
  _ViewIncidentsState createState() => _ViewIncidentsState();
}

class _ViewIncidentsState extends State<ViewIncidents> {
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
                      IconButton(icon: Icon(Icons.add), onPressed: null)
                    ],
                  )
              ),


              _card(Icons.home_outlined, "My Residence", () {}),
              _card(Icons.car_repair, "My Vehicle", () {}),

              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _card(IconData _icon, String title, GestureTapCallback onTap) {
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: InkWell(
          onTap: onTap,
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
                  height: 200,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Car_crash_1.jpg/1024px-Car_crash_1.jpg'),
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
                        Text("My Report Title",style: TextStyle(fontSize:18,fontWeight: FontWeight.w700,color: Colors.black),),

                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text("Brief title description",style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: kPrimaryColor),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Text("Incident",textAlign: TextAlign.center,style: TextStyle(fontSize:13,fontWeight: FontWeight.w300,color: kPrimaryLightColor),),
                              ),
                            )

                          ],
                        ),

                        Divider(color: Colors.grey,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.place,color: Colors.grey,size: 16,),
                                Text("Location",style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,color: Colors.grey,size: 16,),
                                Text("1 hour ago",style: TextStyle(fontSize:14,fontWeight: FontWeight.w300),),
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
  }
}
