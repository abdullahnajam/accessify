import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/navigator/menu_drawer.dart';
class Reservations extends StatefulWidget {
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

  }
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  showApproveDailogBox(){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.3,
                      bottom: MediaQuery.of(context).size.height*0.3,
                      left: MediaQuery.of(context).size.width*0.1,
                      right: MediaQuery.of(context).size.width*0.1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                child: Text(
                                  "Event Request",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.0),
                                ),
                                alignment: Alignment.center,
                              ),
                              GestureDetector(
                                onTap: ()=>Navigator.pop(context),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top:5,right: 10),
                                  child: Icon(Icons.close,size: 24,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child:Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        ),
                        SizedBox(height: 10,),

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child:Text("12/12/21",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,color: Colors.grey,),
                            SizedBox(width: 10,),
                            Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(" FROM  ",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                              Text("  14:00  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                              Text("  TO  ",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                              Text("  18:00  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                            ],
                          )
                        ),


                        SizedBox(height: 20,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: ()=>Navigator.pop(context),
                                color: Colors.green,
                                child: Text('Approve',style: TextStyle(color: Colors.white),),
                              ),
                              SizedBox(width: 20,),
                              RaisedButton(
                                onPressed: ()=>Navigator.pop(context),
                                color: Colors.red,
                                child: Text('Reject',style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(10),
                        )
                      ],
                    )
                )
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
  }
  showReviewDailogBox(){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.2,
                      bottom: MediaQuery.of(context).size.height*0.2,
                      left: MediaQuery.of(context).size.width*0.1,
                      right: MediaQuery.of(context).size.width*0.1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                child: Text(
                                  "Review Event",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.0),
                                ),
                                alignment: Alignment.center,
                              ),
                              GestureDetector(
                                onTap: ()=>Navigator.pop(context),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top:5,right: 10),
                                  child: Icon(Icons.close,size: 24,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child:TextField(
                            maxLines: 3,

                            decoration: InputDecoration(
                              hintText: "Comments"

                            ),
                          )
                        ),
                        SizedBox(height: 10,),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Violation of Regulation",style: TextStyle(
                                  fontSize: 16.0),),
                              Checkbox(value: false, onChanged: null),

                            ],
                          ),
                        ),
                        Container(
                          margin:EdgeInsets.only(top: 5),
                          child: Text(
                            "Photo Evidence",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0),
                          ),
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset('assets/images/add.png',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                            Container(
                              child: Image.asset('assets/images/addImg.jpg',width: 60,height: 60,),
                            ),
                          ],
                        ),


                        SizedBox(height: 20,),
                        Container(
                          child: DefaultButton(
                            text: "Close",
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                          margin: EdgeInsets.all(10),
                        )
                      ],
                    )
                )
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
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
                                  "Reservations",
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
                                "Keep track of the events",
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

              DefaultTabController(
                  length: 3, // length of tabs
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                            indicatorColor: kPrimaryColor,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(width: 4.0,color: kPrimaryColor),
                            ),
                            labelColor:kPrimaryColor,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Events'),
                              Tab(text: 'Ongoing'),
                              Tab(text: 'Ended'),
                            ],
                          ),
                        ),
                        Container( //height of TabBarView
                            height: MediaQuery.of(context).size.height*0.74,

                            child: TabBarView(children: <Widget>[
                              ListView(
                                children: [
                                 GestureDetector(
                                   onTap: ()=>showApproveDailogBox(),
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

                                     margin: EdgeInsets.all(10),
                                     padding: EdgeInsets.all(10),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                             Text("12/12/21",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                           ],
                                         ),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                               children: [
                                                 Icon(Icons.people_outline,color: Colors.grey,),
                                                 Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                               ],
                                             ),
                                             Text("Queued",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                           ],
                                         ),

                                       ],
                                     ),
                                   ),
                                 ),
                                  Container(
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

                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                            Text("12/12/21",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.people_outline,color: Colors.grey,),
                                                Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                              ],
                                            ),
                                            Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
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

                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                            Text("12/12/21",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.people_outline,color: Colors.grey,),
                                                Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                              ],
                                            ),
                                            Text("Rejected",style: TextStyle(color:Colors.red,fontSize: 13,fontWeight: FontWeight.w300),),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ListView(
                                children: [
                                  Container(
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

                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                            Text("12/12/21",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.people_outline,color: Colors.grey,),
                                                Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                              ],
                                            ),


                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ListView(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      showReviewDailogBox();
                                    },
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

                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Facility Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                              Text("12/12/21",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.people_outline,color: Colors.grey,),
                                                  Text("24",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

                                                ],
                                              ),


                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            ])
                        )

                      ])
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
  Widget _card(String title, GestureTapCallback onTap) {
    return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 20.0, top: 10.0),
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(70.0)),
                      color: Colors.white),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.w300,
                              fontSize: 15.5,color: Colors.black),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg')
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Center(

                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
