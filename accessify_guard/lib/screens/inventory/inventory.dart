
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/inventory/asset_model.dart';
import 'package:guard/model/inventory/supply_model.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:guard/provider/UserDataProvider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:toast/toast.dart';
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
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  Future<void> _showEdit(BuildContext context,String id) async {
    String condition='New';

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();







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
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.9,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Inventory Item",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6.apply(color: Colors.black),),
                            ),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Condition",
                            style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.black),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  color: kPrimaryColor,
                                  width: 0.5
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: condition,
                              elevation: 16,
                              isExpanded:true,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (String newValue) {
                                setState(() {
                                  condition = newValue;
                                });
                              },
                              items: <String>['New', 'Plenty', 'Few', 'Empty','Damaged']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          final f = new DateFormat('dd-MM-yyyy');
                          FirebaseFirestore.instance.collection('inventory_assets').doc(id).update({
                            'condition': condition,
                            'lastScanDate': f.format(DateTime.now()).toString()
                          }).then((value) {
                            print("added");
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Toast.show("No record found", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Update",style: Theme.of(context).textTheme.button.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _showSupplyEdit(BuildContext context,String id) async {
    String condition='New';

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();







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
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.9,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Supply Item",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6.apply(color: Colors.black),),
                            ),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Condition",
                            style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.black),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  color: kPrimaryColor,
                                  width: 0.5
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: condition,
                              elevation: 16,
                              isExpanded:true,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (String newValue) {
                                setState(() {
                                  condition = newValue;
                                });
                              },
                              items: <String>['New', 'Plenty', 'Few', 'Empty','Damaged']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          final f = new DateFormat('dd-MM-yyyy');
                          FirebaseFirestore.instance.collection('inventory_supply').doc(id).update({
                            'condition': condition,
                            'lastScanDate': f.format(DateTime.now()).toString()
                          }).then((value) {
                            print("added");
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Toast.show("No record found", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 50,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Update",style: Theme.of(context).textTheme.button.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  scanAsset()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
      _showEdit(context, barcode);
    }

  }
  scanSupply()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
      _showSupplyEdit(context, barcode);
    }

  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

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
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('inventory_assets').where("neighbourId",isEqualTo:provider.userModel.neighbourId).snapshots(),
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
                                          Text("No Assets")

                                        ],
                                      ),
                                    );

                                  }

                                  return new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                      
                                      final model = AssetModel.fromMap(data,document.reference.id);
                                      
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
                                                Text(model.description,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(model.lastScanDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                                Text(model.condition,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                                //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                              ],
                                            ),

                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('inventory_supply').where("neighbourId",isEqualTo:provider.userModel.neighbourId).snapshots(),
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
                                          Text("No Supplies")

                                        ],
                                      ),
                                    );

                                  }

                                  return new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                      final model = SupplyModel.fromMap(data,document.reference.id);

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
                                                Text(model.description,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),


                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(model.lastInventoryDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                                Text(model.condition,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                                                //Text("Approved",style: TextStyle(color:Colors.green,fontSize: 13,fontWeight: FontWeight.w300),),

                                              ],
                                            ),

                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
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
