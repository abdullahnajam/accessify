import 'package:accessify/model/announcement_model.dart';
import 'package:accessify/model/notification_model.dart';
import 'package:accessify/model/survey_model.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
class Survey extends StatefulWidget {
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
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
  List<TextEditingController> desController=[];
  int editingIndex=0;
  List<bool> isChecked=[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
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

                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.only(left:20,top: 10, right: 10),
                        child: GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Text("Survey",style: TextStyle(color:kPrimaryColor,fontWeight: FontWeight.w700,fontSize: 13),),
                    )

                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(5)
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('survey').snapshots(),
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
                            Text("No Questions")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        SurveyModel model=SurveyModel.fromMap(data,document.reference.id,);
                        desController.add(TextEditingController());
                        isChecked.add(false);
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: InkWell(
                              onTap: (){

                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(5),

                                      decoration: BoxDecoration(
                                          color: kPrimaryLightColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                      child: Text(model.question,style: TextStyle(color:Colors.white,fontSize:20,fontWeight: FontWeight.w600),),
                                    ),
                                    if(model.isMCQ)
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: model.choices.length,
                                        itemBuilder: (BuildContext context,int index){
                                          return InkWell(
                                            onTap: (){
                                              setState(() {
                                                isChecked[index]=true;
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top:10),
                                              child:Text(model.choices[index],style: TextStyle(color:Colors.black,fontSize:17),),
                                            ),
                                          );
                                        },
                                      )
                                    )
                                    else
                                      Container(
                                        child: TextFormField(
                                          maxLines: 3,
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
                                            fillColor: Colors.grey[200],
                                            hintText: "Enter Answer",
                                            // If  you are using latest version of flutter then lable text and hint text shown like this
                                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.only(top:10,bottom:20,left: 20,right: 20),
                                      alignment: Alignment.center,
                                      color: kPrimaryColor,
                                      child: Text("Submit",style: TextStyle(color:Colors.white,fontSize:15)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(5),

                                      decoration: BoxDecoration(
                                          color: kPrimaryLightColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)
                                          )
                                      ),
                                      child: Text(model.status,style: TextStyle(color:Colors.white,fontSize:15),),
                                    ),
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
