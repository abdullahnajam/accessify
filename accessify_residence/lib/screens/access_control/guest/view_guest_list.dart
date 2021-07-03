import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:accessify/constants.dart';
import 'package:accessify/model/access/guest.dart';
import 'package:accessify/model/access/qr_image.dart';
import 'package:accessify/screens/access_control/guest/create_guest.dart';
import 'package:accessify/screens/access_control/guest/edit_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
class GuestAccess extends StatefulWidget {
  @override
  _GuestAccessState createState() => _GuestAccessState();
}

class _GuestAccessState extends State<GuestAccess> {
  GlobalKey globalKey = new GlobalKey();
  Future<void> _showInfoDailog(GuestModel model) async {
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
                        Text("Guest Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Email",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.email}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Vehicle",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.vehicle}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                        SizedBox(height: 10,),
                        Text("Start Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Start Hour",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.hour}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("QR Code",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        RepaintBoundary(
                          key: globalKey,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(model.qr),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
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
                                  await databaseReference.child("access_control").child("guest").child(user.uid).child(model.id).remove().then((value) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GuestAccess()));
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
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditGuest(model)));
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
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      String path='${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      File file = await new File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(pngBytes);
      print(file.path);
      print(path);

      Share.shareFiles([path],text: 'QR Code for accesfy');



    }  catch(e) {
      print(e.toString());
    }
  }

  Future<List<GuestModel>> getGuestList() async {
    List<GuestModel> list=new List();
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("access_control").child("guest").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          GuestModel guestModel = new GuestModel(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['email'],
            DATA[individualKey]['date'],
            DATA[individualKey]['hour'],
            DATA[individualKey]['status'],
            DATA[individualKey]['userId'],
            DATA[individualKey]['vehicle'],
            DATA[individualKey]['qr'],
          );
          if(user.uid==guestModel.userId)
            list.add(guestModel);

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
                              "My Guests",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add your Guests here",
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
                              builder: (context) => CreateGuest()));
                        },
                      )
                    ],
                  )
              ),


              FutureBuilder<List<GuestModel>>(
                future: getGuestList(),
                builder: (context,snapshot){
                  if (snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.length>0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                          return Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                onTap: (){
                                  _showInfoDailog(snapshot.data[index]);
                                },
                                child:Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.indigoAccent,
                                        child:  Icon(
                                          Icons.person,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      title: Text("${snapshot.data[index].name}"),
                                      subtitle: Text(snapshot.data[index].date),
                                    ),
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                        caption: 'Share',
                                        color: Colors.indigo,
                                        icon: Icons.share_outlined,
                                        onTap: () => Share.share(snapshot.data[index].qr, subject: 'QR Code for accesfy')
                                    ),
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.indigo,
                                      icon: Icons.edit_outlined,
                                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EditGuest(snapshot.data[index]))),
                                    ),
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.indigo,
                                      icon: Icons.delete_forever_outlined,
                                      onTap: () async{
                                        User user=FirebaseAuth.instance.currentUser;
                                        final databaseReference = FirebaseDatabase.instance.reference();
                                        await databaseReference.child("access_control").child("guest").child(user.uid).child(snapshot.data[index].id).remove().then((value) {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GuestAccess()));
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
                            child: Text("You currently don't have any Guests")
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
