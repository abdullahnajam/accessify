import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/navigator/menu_drawer.dart';
class Notifications extends StatefulWidget {
  @override
  _AccessControlState createState() => _AccessControlState();
}

class _AccessControlState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
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
                            Row(
                              children: [
                                Container(

                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(50)),
                                    margin: EdgeInsets.only(top: 10, right: 10,left: 10),
                                    child: GestureDetector(
                                      onTap: _openDrawer,
                                      child: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )),
                                Text(
                                  "Notifications",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text(
                                "",
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



              _card(),
              _card(),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _card() {
    return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: InkWell(
          onTap: (){

          },
          child: Container(
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
        )
    );
  }
}
