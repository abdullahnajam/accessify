import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:accessify/model/facilities.dart';
import 'package:accessify/model/meeting.dart';
import 'package:accessify/model/reservation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../constants.dart';
import '../home.dart';
class CreateReservation extends StatefulWidget {
  @override
  _CreateReservationState createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey globalKey = new GlobalKey();
  var numberController=TextEditingController();
  String facilitySelected="Select Facility";
  String dateSelected="Select Date";
  String dateFullFormat;
  String selectedFacilityId;



  Future<List<DateTime>> getReservedDates() async {
    List<ReservationModel> list=new List();
    List<DateTime> blackoutDates=[];
    FirebaseFirestore.instance.collection('reservation').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        DateTime parsedDate = DateTime.parse(doc["dateNoFormat"]);
        blackoutDates.add(parsedDate.add(Duration(days: 0)),);
      });
    });


    return blackoutDates;
  }
  File file;
  Future<void> _add() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      String path='${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      file = await new File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(pngBytes);
      print(file.path);
      print(path);

      saveInfo(file);



    }  catch(e) {
      print(e.toString());
    }
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      String path='${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      file = await new File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(pngBytes);
      print(file.path);
      print(path);

      Share.shareFiles([path],text: 'QR Code for accesfy');



    }  catch(e) {
      print(e.toString());
    }
  }
  String qrKey=DateTime.now().millisecondsSinceEpoch.toString();
  Future<void> _generateQRCode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                    child: Column(
                      children: [
                        Container(
                          margin:EdgeInsets.only(top: 10,bottom: 10),
                          child: Text("QR Code",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        ),
                        RepaintBoundary(
                          key: globalKey,
                          child: QrImage(
                            data: qrKey,
                            size: 200,
                            embeddedImage: AssetImage('assets/images/qr_logo.png'),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(50, 50),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[200]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.share),
                          onPressed: _captureAndSharePng
                      ),
                      IconButton(
                          icon: Icon(Icons.file_download),
                          onPressed: null
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    _add();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("Complete Reservation",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  String photoUrl;
  Map<DateTime, List<dynamic>> _events;
  Future<void> _showFacilityDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("facility",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('facility').snapshots(),
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
                            Text("No facilities Added")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        FacilitiesModel model=new FacilitiesModel(
                          document.reference.id,
                          data['facilityName'],
                          data['image'],

                        );
                        return ListTile(
                          onTap: (){
                            setState(() {
                              facilitySelected=model.name;
                              selectedFacilityId=model.id;
                            });
                            Navigator.pop(context);
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(model.image),
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                          ),
                          //leading: Image.network(model.image),
                          title: Text(model.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  saveInfo(File QRfile) async{
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    User user=FirebaseAuth.instance.currentUser;

    var storage = FirebaseStorage.instance;

    TaskSnapshot snapshot = await storage.ref()
        .child('bookingPics/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(QRfile);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        photoUrl = downloadUrl;
      });
      FirebaseFirestore.instance.collection("reservation").doc(qrKey).set({
        'date': dateSelected,
        'dateNoFormat':dateFullFormat,
        'facilityName': facilitySelected,
        'facilityId': selectedFacilityId,
        'totalGuests':numberController.text,
        'hourStart':timeLimit,
        'hourEnd':timeLimit,
        'user':user.uid,
        'qr':photoUrl,
        'status':"pending"
      }).then((value) {
        pr.hide();
        _showSuccessDailog();
      }).catchError((error, stackTrace) {
        pr.hide();
        print("inner: $error");
        // although `throw SecondError()` has the same effect.
        _showFailuresDailog(error.toString());
      });
    }




  }
  String timeLimit="Hours Allowed";
  saveInfoInDb(){
    User user=FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("reservation").add({
      'date': dateSelected,
      'dateNoFormat':dateFullFormat,
      'facilityName': facilitySelected,
      'facilityId': selectedFacilityId,
      'totalGuests':numberController.text,
      'hourStart':timeLimit,
      'hourEnd':timeLimit,
      'user':user.uid,
      'status':"pending"
    }).then((value) {
      _showSuccessDailog();
    })
        .catchError((error, stackTrace) {
      print("inner: $error");
      // although `throw SecondError()` has the same effect.
      _showFailuresDailog(error.toString());
    });
  }
  Future<void> _showSuccessDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/json/success.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: Column(
                      children: [
                        Text("Successful",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Text("Your reservation has been added",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("OKAY",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFailuresDailog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/json/error.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: Column(
                      children: [
                        Text("Error",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                        Text(error,textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),
                      ],
                    )

                ),
                Container(
                  margin: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),
                  child: Divider(color: Colors.grey,),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 40,
                    margin: EdgeInsets.only(left: 40,right: 40),
                    child:Text("OKAY",style: TextStyle(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Container(
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
                              Text(
                                "Add Reservation",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: Text(
                                  "Your can add new reservations here",
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
                Padding(
                  padding:
                  const EdgeInsets.only(left: 25.0, top: 40.0, bottom: 10.0),
                  child: Text(
                    "Fill the Information",
                    style: TextStyle(
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:15,bottom:15,left:10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[200],
                            ),
                            child: Column(
                              children: [
                                FutureBuilder<List<DateTime>>(
                                  future: getReservedDates(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if(snapshot.data!=null){
                                        return SfCalendar(
                                          view: CalendarView.month,
                                          minDate: new DateTime.now(),
                                          blackoutDates: snapshot.data,
                                          onTap: (CalendarTapDetails details){
                                            DateTime date = details.date;
                                            setState(() {
                                              dateSelected=formatDate(date, [dd, '-', mm, '-', yyyy]);
                                              dateFullFormat=date.toString();
                                            });
                                          },
                                        );
                                      }
                                      else{
                                        return SfCalendar(
                                          view: CalendarView.month,
                                          minDate: new DateTime.now(),
                                          onTap: (CalendarTapDetails details){
                                            DateTime date = details.date;
                                            setState(() {
                                              dateSelected=formatDate(date, [dd, '-', mm, '-', yyyy]);
                                              dateFullFormat=date.toString();
                                            });
                                          },
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return Text('Error : ${snapshot.error}');
                                    } else {
                                      return new Container(
                                        margin: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                    padding: EdgeInsets.only(top:15,bottom:15,left:10,right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.grey[200],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.date_range_outlined,color: Colors.black,size: 22,),
                                        ),

                                        Expanded(
                                            flex: 9,
                                            child: Container(
                                              padding: EdgeInsets.only(left:12),
                                              child:Text(dateSelected)
                                            )
                                        )
                                      ],
                                    )
                                ),

                              ],
                            )
                        ),




                        SizedBox(height: 20),

                        Container(
                            padding: EdgeInsets.only(top:15,bottom:15,left:10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.park,color: Colors.black,size: 22,),
                                ),

                                Expanded(
                                    flex: 9,
                                    child: Container(
                                      padding: EdgeInsets.only(left:12),
                                      child:InkWell(
                                          onTap: (){
                                            _showFacilityDailog();
                                          },
                                          child:Text(facilitySelected)
                                      ),
                                    )
                                )
                              ],
                            )
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0.5
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(Icons.people_outline,color: Colors.black,),
                            fillColor: Colors.grey[200],
                            hintText: "Enter number of guests",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),

                        SizedBox(height: 20),


                        GestureDetector(
                          onTap: () async {
                            TimeRange result = await showTimeRangePicker(
                              context: context,
                            );
                            print("result ${result.startTime.hour}:${result.startTime.minute}   TO   ${result.endTime.hour}:${result.endTime.minute}");
                            setState(() {
                              timeLimit="${result.startTime.hour}:${result.startTime.minute}   TO   ${result.endTime.hour}:${result.endTime.minute}";
                            });
                          },
                          child: Container(
                              height: 50,
                              padding: EdgeInsets.only(left:10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.grey[200],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.timer_outlined,color: Colors.black,size: 22,),
                                  ),

                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                        padding: EdgeInsets.only(left:12),
                                        child:Text(timeLimit,style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[700]
                                        ),),
                                      )
                                  )
                                ],
                              )
                          ),
                        ),


                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: (){
                            if (_formKey.currentState.validate()) {
                              _generateQRCode();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: Text("Make Reservation",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30)
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                ),


                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
