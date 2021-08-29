import 'package:accessify/model/notification_model.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                ),

              ),
              child: Stack(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      margin: EdgeInsets.only(left:20,top: 10, right: 10),
                      child: GestureDetector(
                        onTap: _openDrawer,
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Notifications",style: TextStyle(color:kPrimaryColor,fontWeight: FontWeight.w700,fontSize: 13),),
                  )

                ],
              ),
            ),
            Container(
            margin: EdgeInsets.all(5)
          ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).
                  where('userId', isEqualTo: "all").snapshots(),
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
                          Text("No Notifications")

                        ],
                      ),
                    );

                  }

                  return new ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      NotificationModel model=new NotificationModel(
                        document.reference.id,
                        data['isOpened'],
                        data['type'],
                        data['date'],
                        data['body'],
                        data['title'],
                        data['icon'],
                        data['userId'],
                      );
                      return Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(

                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(width: 0.2, color: Colors.grey[500]),
                                  bottom: BorderSide(width: 0.1, color: Colors.grey[500]),
                                ),

                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child:Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image: new NetworkImage(model.icon),
                                              )
                                          )
                                      )


                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(model.title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                            Text(model.body,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                                          ],
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            model.date==null?Text(""):Text(timeAgoSinceDate(model.date),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                                            Text(model.type,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                                          ],
                                        ),
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
            ),

          ],
        ),
      )
    );
  }
}
