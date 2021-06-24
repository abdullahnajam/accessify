import 'package:firebase_database/firebase_database.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/inventory/asset_model.dart';
import 'package:guard/model/inventory/supply_model.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

  }
  Future<List<AssetModel>> getAssets() async {
    List<AssetModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("inventory").child("asset").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          AssetModel assetModel = new AssetModel(
            individualKey,
            DATA[individualKey]['assignedTo'],
            DATA[individualKey]['condition'],
            DATA[individualKey]['datePurchased'],
            DATA[individualKey]['description'],
            DATA[individualKey]['lastScanDate'],
            DATA[individualKey]['location'],
            DATA[individualKey]['photo'],
            DATA[individualKey]['serialNumber'],
            DATA[individualKey]['warranty'],
          );
          list.add(assetModel);

        }
      }
    });

    return list;
  }
  Future<List<SupplyModel>> getSupply() async {
    List<SupplyModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("inventory").child("supply").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          SupplyModel assetModel = new SupplyModel(
            individualKey,
            DATA[individualKey]['assignedTo'],
            DATA[individualKey]['condition'],
            DATA[individualKey]['datePurchased'],
            DATA[individualKey]['description'],
            DATA[individualKey]['lastScanDate'],
            DATA[individualKey]['location'],
            DATA[individualKey]['photo'],
            DATA[individualKey]['serialNumber'],
            DATA[individualKey]['warranty'],
          );
          list.add(assetModel);

        }
      }
    });

    return list;
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
  scanAsset()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
    }

  }
  scanSupply()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: (){
          if(_tabController==0){
            scanAsset();
          }
          else{
            scanSupply();
          }
        },
        child: Icon(Icons.qr_code_scanner_outlined),
      ),
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
                                  "Inventory",
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
                                "Keep track of the list of inventory items",
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
                              Tab(text: 'Assets'),
                              Tab(text: 'Supplies'),
                            ],
                          ),
                        ),
                        Container( //height of TabBarView
                            height: MediaQuery.of(context).size.height*0.74,

                            child: TabBarView(children: <Widget>[
                              FutureBuilder<List<AssetModel>>(
                                future: getAssets(),
                                builder: (context,snapshot){
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null && snapshot.data.length>0) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        //scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context,int index){
                                          return Container(
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
                                                    Text(snapshot.data[index].description,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),


                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data[index].lastScanDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                                    Text(snapshot.data[index].condition,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                                    //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      return new Center(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 100),
                                            child: Text("You currently don't have any assets")
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
                              FutureBuilder<List<SupplyModel>>(
                                future: getSupply(),
                                builder: (context,snapshot){
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null && snapshot.data.length>0) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        //scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context,int index){
                                          return Container(
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
                                                    Text(snapshot.data[index].description,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),


                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data[index].lastScanDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                                    Text(snapshot.data[index].condition,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                                    //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      return new Center(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 50),
                                            child: Text("You currently don't have any supplies")
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
