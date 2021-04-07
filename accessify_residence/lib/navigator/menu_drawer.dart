import 'package:accessify/screens/payments/my_payments.dart';
import 'package:flutter/material.dart';
import 'package:accessify/data/img.dart';
import 'package:accessify/data/my_colors.dart';
import 'package:accessify/widget/my_text.dart';
import 'package:accessify/widget/toolbar.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(height: 30),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: MyColors.grey_20,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'),
                    ),
                  ),
                  Container(height: 7),
                  Text("My Name", style: MyText.body2(context).copyWith(
                      color: Colors.blueGrey[800], fontWeight: FontWeight.w500
                  )),
                  Container(height: 2),
                  Text("myemailid@mail.com", style: MyText.caption(context).copyWith(
                      color: MyColors.grey_20, fontWeight: FontWeight.w500
                  ))
                ],
              ),
            ),
            Container(height: 8),
            InkWell(onTap: (){},
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.label, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Coupons", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyPayments()));
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.monetization_on, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Payment", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),

            Container(height: 10),
            InkWell(onTap: (){},
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.language, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Change Language", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
            Container(height: 10),
            InkWell(onTap: (){},
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.power_settings_new, color: MyColors.grey_20, size: 20),
                    Container(width: 20),
                    Expanded(child: Text("Logout", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
