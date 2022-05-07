import 'package:accessify/model/notification_model.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:accessify/provider/UserDataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

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
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      key: _drawerKey,
      backgroundColor: bgColor,
      drawer: MenuDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.15, color: kPrimaryColor),
                ),
              ),
              height:  AppBar().preferredSize.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Notifications',style: TextStyle(color: kPrimaryColor),),
                  )
                ],
              ),
            ),
            Container(
            margin: EdgeInsets.all(5)
          ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications')
                    .where('userId', whereIn: [FirebaseAuth.instance.currentUser.uid,"all"])
                  .where('neighbourId', isEqualTo: provider.userModel.neighbourId).snapshots(),
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        )
                                    ),
                                    child: Text(model.type.toUpperCase(),style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              height: 30,width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(model.icon)
                                                  )
                                              ),

                                            ),
                                            Expanded(
                                              child: Text(model.title,style: TextStyle(fontWeight: FontWeight.w500),maxLines: 1,),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(model.body),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
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
