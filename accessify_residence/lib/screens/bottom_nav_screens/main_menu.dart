import 'package:accessify/auth/sign_in/sign_in_screen.dart';
import 'package:accessify/constants.dart';
import 'package:accessify/model/access_control_model.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:accessify/screens/access_control/main_screen.dart';
import 'package:accessify/screens/home.dart';
import 'package:accessify/screens/incidents/view_incidents.dart';
import 'package:accessify/screens/my_home/my_home.dart';
import 'package:accessify/screens/reservation/view_reservation_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _message = '';



  /*void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
          setState(() => _message = message["notification"]["body"]);
          showOverlayNotification((context) {
            return Card(
              margin: EdgeInsets.all(10),
              child: SafeArea(
                child: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      }),
                ),
              ),
            );
          }, duration: Duration(milliseconds: 4000));
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["body"]);
    });
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    getUserData();
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
      else{
        if(FirebaseAuth.instance.currentUser!=null)
          FirebaseAuth.instance.signOut();
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => SignInScreen()));
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      backgroundColor: bgColor,
      body: isLoading?
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.33,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: <Widget>[

                    Row(
                      children: [
                        Container(

                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            margin: EdgeInsets.only(top: 10, right: 10,left: 10),
                            child: GestureDetector(
                              onTap: _openDrawer,
                              child: Icon(
                                Icons.menu,
                                color: Colors.blue,
                                size: 30,
                              ),
                            )),
                        Text(
                          "Accesfy",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        'title'.tr(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AccessControl()));
                          },
                          child:Container(
                            height: 50,
                            //width: MediaQuery.of(context).size.width*0.5,
                            padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'addAccess'.tr(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13.0),
                                  ),
                                ),
                                Container(
                                  //color: Colors.grey,
                                  child: Lottie.asset(
                                    'assets/json/access.json',
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('access_control')
              .where("neighbourId",isEqualTo:userModel.neighbourId)
                  .where("requestedBy",isEqualTo:"${userModel.firstName} ${userModel.lastName}")
                  .orderBy("datePostedInMilli",descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset("assets/json/error.json",width: 150,height: 150,),
                        Text("Something Went Wrong")

                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.size==0){
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset("assets/json/empty.json",width: 150,height: 150,),
                        Text('noDataFound'.tr(),)
                      ],
                    ),
                  );
                }
                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    AccessControlModel model=AccessControlModel.fromMap(data, document.reference.id);
                    return new Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),

                            margin: EdgeInsets.fromLTRB(10,10,10,0),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${model.type} - ${model.requestedFor}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),


                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(model.date,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),
                                    Text(model.status,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                    //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                  ],
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
          )


        ],
      )
      :
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
