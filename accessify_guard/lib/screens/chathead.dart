import 'package:guard/components/default_button.dart';
import 'package:guard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/navigator/menu_drawer.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  showDeliveryServiceDailog(){
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
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
        });
  }
  showUnRegisteredDailog(){
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
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
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
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Visitor Name",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          height: 60,
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Contact Name",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
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
                          margin: EdgeInsets.only(left: 10,right: 10),
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
                        SizedBox(height: 20,),
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            decoration: InputDecoration(
                              hintText: "Address",
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery",style: TextStyle(
                                  fontSize: 16.0),),
                              Checkbox(value: false, onChanged: null),

                            ],
                          ),
                        ),

                        Container(
                          margin:EdgeInsets.only(top: 5),
                          child: Text(
                            "Photo Order",
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
                            text: "Request Approval",
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
                                  "Conversations",
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



              _card(Icons.delivery_dining, "Delivery Service", () =>showDeliveryServiceDailog()),
              _card(Icons.local_taxi, "My Taxi", () =>showDeliveryServiceDailog()),

              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _card(IconData _icon, String title, GestureTapCallback onTap) {
    return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: InkWell(
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatBBMRoute(widget.userId,chats.data[index]),
              ),
            );*/
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(50),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:BorderRadius.circular(35),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'),
                          ),
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'username',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Text(
                        'subject',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
