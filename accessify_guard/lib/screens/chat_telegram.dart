import 'package:flutter/material.dart';
import 'package:guard/adapter/chat_telegram_adapter.dart';
import 'package:guard/constants.dart';
import 'package:guard/data/img.dart';
import 'package:guard/data/my_colors.dart';
import 'package:guard/model/message.dart';
import 'package:guard/utils/tools.dart';
import 'package:guard/widget/circle_image.dart';
import 'package:guard/widget/my_text.dart';
import 'dart:async';

class ChatTelegramRoute extends StatefulWidget {

  ChatTelegramRoute();

  @override
  ChatTelegramRouteState createState() => new ChatTelegramRouteState();
}


class ChatTelegramRouteState extends State<ChatTelegramRoute> {

  bool showSend = false;
  final TextEditingController inputController = new TextEditingController();
  List<Message> items = [];
  ChatTelegramAdapter adapter;

  @override
  void initState() {
    super.initState();
    items.add(Message.time(items.length, "Hai..", false, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
    items.add(Message.time(items.length, "Hello!", true, items.length % 5 == 0, Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)));
  }

  @override
  Widget build(BuildContext context) {
    adapter = ChatTelegramAdapter(context, items, onItemClick);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Row(
            children: <Widget>[
              CircleImage(
                imageProvider: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'), size: 40,
              ),
              Container(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Mary Jackson", style: TextStyle(color: Colors.white)),
                  Container(height: 2),
                  Text("Online", style: TextStyle(color: Colors.grey)
                  ),
                ],
              )
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

      ),
      body: Container(
        width: double.infinity, height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: adapter.getView(),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[

                  Expanded(
                    child: TextField(
                      controller: inputController,
                      maxLines: 1, minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: new InputDecoration.collapsed(
                          hintText: 'Message'
                      ),
                      onChanged: (term){
                        setState(() { showSend = (term.length > 0); });
                      },
                    ),
                  ),
                  IconButton(icon: Icon(Icons.attach_file, color: MyColors.grey_60), onPressed: () {}),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onItemClick(int index, String obj) { }

  void sendMessage(){
    String message = inputController.text;
    inputController.clear();
    showSend = false;
    setState(() {
      adapter.insertSingleItem(
          Message.time(adapter.getItemCount(), message, true,
              adapter.getItemCount() % 5 == 0,
              Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)
          )
      );
    });
    generateReply(message);
  }

  void generateReply(String msg){
    Timer(Duration(seconds: 1), () {
      setState(() {
        adapter.insertSingleItem(
            Message.time(adapter.getItemCount(), msg, false, adapter.getItemCount() % 5 == 0,
                Tools.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch)
            )
        );
      });
    });
  }
}

