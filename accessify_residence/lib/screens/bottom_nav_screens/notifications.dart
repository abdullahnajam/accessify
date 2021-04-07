import 'package:accessify/navigator/menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
            margin: EdgeInsets.all(15),
            child: Text(
              "Announcement & Surveys",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child:Container(
                      margin: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage("https://image.freepik.com/free-vector/society-concept-illustration_1284-8297.jpg"),
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
                        Text("Title",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                        Text("Description",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1 hour ago",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                        Text("Announcement",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                      ],
                    ),
                  )
                ),

              ],
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child:Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage("https://image.freepik.com/free-vector/society-concept-illustration_1284-8297.jpg"),
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
                          Text("Title",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                          Text("Description",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1 hour ago",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          Text("Survey",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                        ],
                      ),
                    )
                ),

              ],
            ),
          ),
          ],
        ),
      )
    );
  }
}
