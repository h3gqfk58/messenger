import 'package:chat_app_1/helper/authenticate.dart';
import 'package:chat_app_1/helper/constants.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:chat_app_1/services/database.dart';
import 'package:chat_app_1/views/sign_in.dart';
import 'package:chat_app_1/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_1/services/auth.dart';

class chat_screen extends StatefulWidget {
  @override
  _chat_screenState createState() => _chat_screenState();

}

class _chat_screenState extends State<chat_screen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController messageTextEditingController = new TextEditingController();

  QuerySnapshot allChats;
  Map<dynamic, dynamic> messageMap;

  sendMessage() {
    Map<String, dynamic> chatMap = {
      "by" : Constants.currentEmail,
      "message" : messageTextEditingController.text,
      "time" : DateTime.now(),
    };
    databaseMethods.addMessage(Constants.chatRoomID, chatMap);
    messageTextEditingController.text = "";
  }

  getAllChats() {
    databaseMethods.getChats(Constants.chatRoomID).then((val){
      setState(() {
        allChats = val;
      });
    });
  }

  Widget chatMessageList() {
    return (allChats != null) ? ListView.builder(
      primary: false,
      itemCount: allChats.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        messageMap = allChats.docs[index].data();
        return Tile(
          by: messageMap["by"].toString(),
          message: messageMap["message"].toString(),
        );
      },
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    getAllChats();
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/chat_app_logo.png", height: 30,),
        brightness: Brightness.dark,
      ),
      body: Container(
        child: Stack(
          children: [
            /*Column(
              mainAxisSize: MainAxisSize.min,
              children : [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.topLeft,
                  color: Color(0x54FFFFFF),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : [
                        Text(Constants.receivedUsername, style: buttonTextStyle(),),
                        Text("   -   " + Constants.receivedEmail, style: simpleTextStyle(),),
                      ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  alignment: Alignment.topLeft,
                  color: Color(0x54FFFFFF),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : [
                        Text(Constants.chatRoomID, style: smallTextStyle(),),
                      ]
                  ),
                ),
              ]
            ),*/
            Container(
              height: MediaQuery.of(context).size.height - 160,
              child: Scrollbar(
                  child: chatMessageList()
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color:  Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 25),
                          child: TextField(
                            controller: messageTextEditingController,
                            style: textFieldStyle(),
                            decoration: InputDecoration(
                              hintText: "Message..",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container (
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                        child: Image.asset("assets/images/message_arrow.png"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class Tile extends StatelessWidget {
  final String by, message;
  Tile({this.by, this.message});

  _chat_screenState chat_screen_instance = new _chat_screenState();

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          if(by != "system") Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(by == Constants.receivedEmail) Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: Text(message, style: buttonTextStyle())
                  )
                  else if(by == Constants.currentEmail) Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children : [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Text(message, style: buttonTextStyle())
                      ),
                    ]
                  ),
                ]
            ),
          ),
        ]
    );
  }
}