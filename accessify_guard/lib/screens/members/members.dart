import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/user_model.dart';
import 'package:guard/navigator/menu_drawer.dart';
class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    getUserData();

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
  UserModel userModel;
  bool isLoading=false;

  getUserData()async{
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('guard')
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
    });

  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: isLoading?Container(
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
                                  "Members",
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
                                "Keep track of the list of members",
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
                  length: 2, // length of tabs
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
                              Tab(text: 'Active'),
                              Tab(text: 'Inactive'),
                            ],
                          ),
                        ),
                        Container( //height of TabBarView
                            height: MediaQuery.of(context).size.height*0.74,

                            child: TabBarView(children: <Widget>[
                              Container(
                                child:  StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('homeowner')
                                      .where("neighbourId",isEqualTo:userModel.neighbourId).snapshots(),
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
                                            Text("No Users")

                                          ],
                                        ),
                                      );

                                    }

                                    return new ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                        final model = UserModel.fromMap(data,document.reference.id);

                                        return  _card (model.firstName, () { });
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                child:  StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('homeowner').snapshots(),
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
                                            Text("No Users")

                                          ],
                                        ),
                                      );

                                    }

                                    return new ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                        final model = UserModel.fromMap(data,document.reference.id);

                                        return  _card (model.firstName, () { });
                                      }).toList(),
                                    );
                                  },
                                ),
                              )

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
      ):Center(child: CircularProgressIndicator(),),
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
