import 'package:accessify/model/reservation_model.dart';
import 'package:accessify/screens/reservation/create_reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class ViewReservations extends StatefulWidget {
  @override
  _ViewReservationsState createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> {
  Future<void> _showInfoDailog(ReservationModel model) async {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Reservation Information",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Facility Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.facilityName}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                        SizedBox(height: 10,),
                        Text("Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Guests",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.totalGuests}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Hours",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.hourStart}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),




                        SizedBox(height: 10,),
                        Text("QR Code",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(model.qr),
                                  fit: BoxFit.cover
                              )
                          ),
                        )




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
  Future<List<ReservationModel>> getReservedDates() async {
    List<ReservationModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("reservation").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          ReservationModel reservationModel = new ReservationModel(
            individualKey,
            DATA[individualKey]['date'],
            DATA[individualKey]['facilityName'],
            DATA[individualKey]['facilityId'],
            DATA[individualKey]['totalGuests'],
            DATA[individualKey]['hourStart'],
            DATA[individualKey]['hourEnd'],
            DATA[individualKey]['user'],
            DATA[individualKey]['dateNoFormat'],
            DATA[individualKey]['qr'],
          );
          if(reservationModel.userId==user.uid){
            list.add(reservationModel);
          }

          //DateTime parsedDate = DateTime.parse(reservationModel.dateNoFormat);

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
                    IconButton(icon: Icon(Icons.add), onPressed: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => CreateReservation()));
                    })
                  ],
                )
              ),
              FutureBuilder<List<ReservationModel>>(
                future: getReservedDates(),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.length>0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                          return _card(snapshot.data[index]);
                        },
                      );
                    }
                    else {
                      return new Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Text("You currently don't have any reservation")
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
  Widget _card(ReservationModel reservation) {
    return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: InkWell(
          onTap: (){
            _showInfoDailog(reservation);
          },
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
                        Text(reservation.facilityName,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),),
                        Text(reservation.date,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        Text(reservation.hourStart,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
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
                                  Text(reservation.totalGuests,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
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
