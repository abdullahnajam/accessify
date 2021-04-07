import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class ViewReservations extends StatefulWidget {
  @override
  _ViewReservationsState createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> {
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
                              "My Reservation",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and create your reservations here",
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
                      "Reservations",
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
            height: 70,
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
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Place Name",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),),
                        Text("21/03/2020",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        Text("11:00 AM - 01:00 PM",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(color: Colors.grey,),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("My Name",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),),
                              Row(
                                children: [
                                  Text("21",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                                  SizedBox(width: 5,),
                                  Icon(Icons.people,color: Colors.grey,size: 18,),

                                ],
                              )
                            ],
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(100)
                            ),
                          ),
                          flex: 2,
                        )
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
