import 'package:accessify/model/announcement_model.dart';
import 'package:accessify/model/notification_model.dart';
import 'package:accessify/model/survey_model.dart';
import 'package:accessify/model/user_model.dart';
import 'package:accessify/navigator/menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../constants.dart';
class Survey extends StatefulWidget {
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool surveyLoad=false;
  Future getQuestions()async{
    setState(() {
      surveyLoad=false;
      surveys=[];
      isChecked=[];
      desController=[];
    });
    await FirebaseFirestore.instance.collection('survey').where("neighbourId",isEqualTo: userModel.neighbourId)
        .where("status",isNotEqualTo: "Closed")
        .get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            SurveyModel model = SurveyModel.fromMap(data, doc.reference.id);
            print("al ${model.attempts.length}");
            if(!model.attempts.contains(FirebaseAuth.instance.currentUser.uid)){
              print("al ${model.attempts.length}");
              setState(() {
                surveys.add(model);
                desController.add(TextEditingController());
                List<bool> choices=[];
                if(model.isMCQ){
                  model.choices.forEach((element) => choices.add(false));
                  isChecked.add(choices);
                }
                else{
                  isChecked.add([]);
                }
              });
            }


        });
      });
    setState(() {
      surveyLoad=true;
    });
  }

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
  List<SurveyModel> surveys=[];
  List<List<bool>> isChecked=[];

  UserModel userModel;
  bool isLoading=false;

  Future getUserData()async{
    User user=FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('homeowner')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        userModel=UserModel.fromMap(data, documentSnapshot.reference.id);
        print("id : ${userModel.neighbourId}");
        setState(() {
          isLoading=true;
        });
        getQuestions();
      }
    });

  }


  @override
  void initState() {
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _drawerKey,
        drawer: MenuDrawer(),
        body: SafeArea(
          child: isLoading?
          Column(
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
              if(surveys.length>0)
                Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: surveys.length,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryLightColor),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)
                                    )
                                ),
                                child: Text(surveys[index].status,style: TextStyle(color:Colors.white,fontSize:14,fontWeight: FontWeight.w300),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(surveys[index].question,style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.w500),),
                              ),

                              if(surveys[index].isMCQ)
                                Container(
                                    margin: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: surveys[index].choices.length,
                                      itemBuilder: (BuildContext context,int i){
                                        return CheckboxListTile(
                                          title: Text(surveys[index].choices[i]),
                                          value: isChecked[index][i],
                                          controlAffinity: ListTileControlAffinity.leading,
                                          onChanged: (bool value) {
                                            setState(() {
                                              isChecked[index][i]=value;
                                              for(int j=0;j<isChecked[index].length;j++){
                                                if(j!=i)
                                                  isChecked[index][j]=false;
                                              }
                                            });
                                          },
                                        );
                                      },
                                    )
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: TextFormField(
                                      maxLines: 3,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'pleaseEnterSomeText'.tr();
                                        }
                                        return null;
                                      },
                                      controller: desController[index],
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
                                ),
                              InkWell(
                                onTap:()async{
                                  final ProgressDialog pr = ProgressDialog(context);
                                  pr.style(message: "Please wait");
                                  pr.show();
                                  String selected="";
                                  for(int i=0;i<surveys[index].choices.length;i++){
                                    if(isChecked[index][i]){
                                      selected=surveys[index].choices[i];
                                    }
                                  }
                                  //audience,description,information,photo,expDate;bool neverExpire
                                  await FirebaseFirestore.instance.collection('attempts').add({
                                    'questionId': surveys[index].id,
                                    'answer': desController[index].text,
                                    'choiceSelected': selected,
                                    'isMCQ':  surveys[index].isMCQ,
                                    'userId': FirebaseAuth.instance.currentUser.uid,
                                    'neighbourId': userModel.neighbourId,
                                    'name': "${userModel.firstName} ${userModel.lastName}",
                                  }).then((value) async{
                                    List attempts=surveys[index].attempts;
                                    attempts.add(FirebaseAuth.instance.currentUser.uid);
                                    await FirebaseFirestore.instance.collection("survey").doc(surveys[index].id).update({
                                      'attempts': attempts,
                                    });
                                    getQuestions();
                                    pr.hide();
                                    print("added");
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(top:10,bottom:20,left: 20,right: 20),
                                  alignment: Alignment.center,
                                  color: kPrimaryColor,
                                  child: Text("Submit",style: TextStyle(color:Colors.white,fontSize:15)),
                                ),
                              ),

                            ],
                          ),
                        )
                    );
                  }
                  ,
                ),
              )
              else
                Center(
                  child: Text("No Data"),
                )

            ],
          ):Center(child: CircularProgressIndicator(),),
        )
    );
  }
}
