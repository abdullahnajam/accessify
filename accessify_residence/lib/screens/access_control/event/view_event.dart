import 'package:accessify/model/access/event.dart';
import 'package:accessify/screens/access_control/event/create_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import '../../../constants.dart';
class ViewEvents extends StatefulWidget {
  @override
  _ViewEventsState createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  Future<void> _showGuestDailog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Visitors List",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("event_access").doc(id).collection("visitors").snapshots(),
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
                            Text("No Delivery Added")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              child: Text(data['name'][0].toUpperCase()),
                              backgroundColor: Colors.indigoAccent,
                              foregroundColor: Colors.white,
                            ),
                            title: Text("${data['name']}"),
                            subtitle: Text("${data['email']}"),
                          ),
                        );
                      }).toList(),
                    );
                  },
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
  GlobalKey globalKey = new GlobalKey();
  Future<void> _showInfoDailog(EventModel model) async {
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
                        Text("Event Information",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        SizedBox(height: 10,),
                        Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.name}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Location",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.location}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                        SizedBox(height: 10,),
                        Text("Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.date}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


                        SizedBox(height: 10,),
                        Text("Start Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                        Text("${model.startTime}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),


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
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(icon: Icon(Icons.delete_forever_outlined), onPressed: ()async{
                                FirebaseFirestore.instance.collection("event_access").doc(model.id).delete().then((value) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ViewEvents()));
                                });
                              }),
                              IconButton(icon: Icon(Icons.share_outlined), onPressed: (){
                                _captureAndSharePng();
                              })
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
                              "My Events",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "Your can view and add your events here",
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
                              builder: (context) => CreateEvent()));
                        },
                      )
                    ],
                  )
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('event_access').where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                          Text("No Events Added")

                        ],
                      ),
                    );

                  }

                  return new ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      EventModel model=new EventModel(
                        document.reference.id,
                        data['name'],
                        data['location'],
                        data['date'],
                        data['startTime'],
                        data['guests'],
                        data['qr'],
                        data['userId'],
                      );
                      return Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
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
                                      Icons.calendar_today_outlined,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text("${model.name}"),
                                  subtitle: Text(model.date),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                    caption: 'Share',
                                    color: Colors.indigo,
                                    icon: Icons.share_outlined,
                                    onTap: () => Share.share(model.qr, subject: 'QR Code for accesfy')
                                ),
                                IconSlideAction(
                                    caption: 'Guest List',
                                    color: Colors.indigo,
                                    icon: Icons.assignment_outlined,
                                    onTap: ()=>_showGuestDailog(model.id)
                                ),
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.indigo,
                                  icon: Icons.delete_forever_outlined,
                                  onTap: () async{
                                    User user=FirebaseAuth.instance.currentUser;
                                    FirebaseFirestore.instance.collection("event_access").doc(model.id).delete().then((value) {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ViewEvents()));
                                    });
                                  },
                                ),
                              ],

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
