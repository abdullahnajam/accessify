import 'package:accessify/model/vehicle_model.dart';
import 'package:accessify/screens/my_home/create_vehicle.dart';
import 'package:accessify/screens/my_home/edit_vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants.dart';
class MyVehicle extends StatefulWidget {
  @override
  _MyVehicleState createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {
  Future<void> _showInfoDailog(VehicleModel vehicleModel) async {
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
                        Text("Vehicle Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Vehicle Make",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${vehicleModel.make}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Model",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${vehicleModel.model}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                        SizedBox(height: 10,),
                        Text("Year",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${vehicleModel.year}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Color",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${vehicleModel.color}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Number Plate",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${vehicleModel.plate}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Actions",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: ()async{
                                  User user=FirebaseAuth.instance.currentUser;
                                  final databaseReference = FirebaseDatabase.instance.reference();
                                  await databaseReference.child("home").child("vehicles").child(user.uid).child(vehicleModel.id).remove().then((value) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyVehicle()));
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
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditVehicle(vehicleModel)));
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

  Future<List<VehicleModel>> getVehicleList() async {
    List<VehicleModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("home").child("vehicles").child(user.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          VehicleModel vehicleModel = new VehicleModel(
            individualKey,
            DATA[individualKey]['make'],
            DATA[individualKey]['model'],
            DATA[individualKey]['color'],
            DATA[individualKey]['plate'],
            DATA[individualKey]['year'],
            DATA[individualKey]['newTag'],
            DATA[individualKey]['feeAcceptance'],
          );
          print("key ${vehicleModel.id}");
          list.add(vehicleModel);

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
                              "My Vehicles",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add your vehicles here",
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
                              builder: (context) => CreateVehicle()));
                        },
                      )
                    ],
                  )
              ),


              FutureBuilder<List<VehicleModel>>(
                future: getVehicleList(),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.length>0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,int index){
                          return Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                onTap: (){
                                  _showInfoDailog(snapshot.data[index]);
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
                                          Icons.car_repair,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      title: Text("${snapshot.data[index].model} ${snapshot.data[index].year}"),
                                      subtitle: Text(snapshot.data[index].plate),
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.indigo,
                                      icon: Icons.edit_outlined,
                                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EditVehicle(snapshot.data[index]))),
                                    ),
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.indigo,
                                      icon: Icons.delete_forever_outlined,
                                      onTap: () async{
                                        User user=FirebaseAuth.instance.currentUser;
                                        final databaseReference = FirebaseDatabase.instance.reference();
                                        await databaseReference.child("home").child("vehicles").child(user.uid).child(snapshot.data[index].id).remove().then((value) {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyVehicle()));
                                        });
                                      },
                                    ),
                                  ],

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
                            child: Text("You currently don't have any vehicle")
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
