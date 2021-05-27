import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/model/notification_model.dart';
import 'package:guard/navigator/menu_drawer.dart';
import 'package:guard/screens/addAccessControlMember.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
class Notifications extends StatefulWidget {
  @override
  _AccessControlState createState() => _AccessControlState();
}

class _AccessControlState extends State<Notifications> {
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
  String qrcode;

  openDailog(){
    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.2,
                  bottom: MediaQuery.of(context).size.height*0.25,
                  left: MediaQuery.of(context).size.width*0.1,
                  right: MediaQuery.of(context).size.width*0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            margin:EdgeInsets.only(top: 5),
                            child: Text(
                              "Register",
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
                              margin: EdgeInsets.all(10),
                              child: Icon(Icons.close,size: 24,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width*0.7,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "ID Number",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width*0.7,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Vehicle Plate",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

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
                        GestureDetector(
                          onTap: pickImage,
                          child: _imageFile==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile,width: 60,height: 60,),
                        ),
                        GestureDetector(
                          onTap: pickImage2,
                          child: _imageFile2==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile2,width: 60,height: 60,),
                        ),
                        GestureDetector(
                          onTap: pickImage3,
                          child: _imageFile3==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile3,width: 60,height: 60,),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: DefaultButton(
                        text: "Continue",
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                      margin: EdgeInsets.all(10),
                    )
                  ],
                )
            );
          },
        );
      },
    );
  }


  showsDialog(BuildContext context){
    final idNumberController=TextEditingController();
    final plateController=TextEditingController();
    showGeneralDialog(

        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return StatefulBuilder(builder: (context,setState){
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
                        bottom: MediaQuery.of(context).size.height*0.25,
                        left: MediaQuery.of(context).size.width*0.1,
                        right: MediaQuery.of(context).size.width*0.1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Register",
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
                                    margin: EdgeInsets.all(10),
                                    child: Icon(Icons.close,size: 24,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: idNumberController,
                              decoration: InputDecoration(
                                hintText: "ID Number",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: plateController,
                              decoration: InputDecoration(
                                hintText: "Vehicle Plate",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

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
                              GestureDetector(
                                onTap: pickImage,
                                child: _imageFile==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile,width: 60,height: 60,),
                              ),
                              GestureDetector(
                                onTap: pickImage2,
                                child: _imageFile2==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile2,width: 60,height: 60,),
                              ),
                              GestureDetector(
                                onTap: pickImage3,
                                child: _imageFile3==null?Image.asset('assets/images/add.png',width: 60,height: 60,):Image.file(_imageFile3,width: 60,height: 60,),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: DefaultButton(
                              text: "Continue",
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
          });
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
  }

  showDeliveryServiceDailog()async{

    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print('qr code $barcode');
      showsDialog(context);
    }

  }
  List<String> urls=[];
  Future uploadImageToFirebase(BuildContext context,File file) async {
    String fileName = file.path;


    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        urls.add(downloadUrl);
      });
    }
  }
  final picker = ImagePicker();
  File _imageFile,_imageFile2,_imageFile3;
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
      print("file1 = ${_imageFile.path}");
    });
    uploadImageToFirebase(context,_imageFile);
  }
  Future pickImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile2 = File(pickedFile.path);
    });
    uploadImageToFirebase(context,_imageFile2);
  }
  Future pickImage3() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile3 = File(pickedFile.path);
    });
    uploadImageToFirebase(context,_imageFile3);
  }

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  Future<List<NotificationModel>> getNotificationList() async {
    
    List<NotificationModel> list=[];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("notifications").child("guard").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          NotificationModel notificationModel = new NotificationModel(
              individualKey,
              DATA[individualKey]['isOpened'],
              DATA[individualKey]['type'],
              DATA[individualKey]['date'],
              DATA[individualKey]['body'],
              DATA[individualKey]['title'],
              DATA[individualKey]['icon'],
              DATA[individualKey]['userId']
          );
          list.add(notificationModel);



        }
      }
    });
    return list;
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
              Container(
                child: FutureBuilder<List<NotificationModel>>(
                  future: getNotificationList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          //scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: InkWell(
                                  onTap: (){
                                      if(snapshot.data[index].type=="Delivery" || snapshot.data[index].type=="Taxi"){
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) => AddAccessControlMember(snapshot.data[index])));
                                      }
                                      else{
                                        showDeliveryServiceDailog();
                                      }
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
                                                      image: new NetworkImage(snapshot.data[index].icon),
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
                                                  Text(snapshot.data[index].title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                                  Text(snapshot.data[index].body,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
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
                                                  snapshot.data[index].date==null?Text(""):Text(timeAgoSinceDate(snapshot.data[index].date),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                                                  Text(snapshot.data[index].type,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.grey[500]),)
                                                ],
                                              ),
                                            )
                                        ),

                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 100),
                              child: Text("You currently don't have any notifications")
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
