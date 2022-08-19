import 'package:chat_app_1/helper/authenticate.dart';
import 'package:chat_app_1/helper/constants.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:chat_app_1/services/database.dart';
import 'package:chat_app_1/views/sign_in.dart';
import 'package:chat_app_1/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_1/services/auth.dart';

import 'chat_screen.dart';

class chat_home extends StatefulWidget {
  @override
  _chat_homeState createState() => _chat_homeState();

}

class _chat_homeState extends State<chat_home> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot allUsers, chatRooms;

  Map<dynamic, dynamic> userInfoMap;

  getAllUsers(){
    databaseMethods.getUsers().then((val){
      setState(() {
        allUsers = val;
      });
    });
  }

  sendToChatScreen(String receivedEmail, String receivedUsername) {
    Constants.receivedEmail = receivedEmail;
    Constants.receivedUsername = receivedUsername;

    if(Constants.currentEmail.compareTo(Constants.receivedEmail) < 0) {
      Constants.chatRoomID = Constants.currentEmail + "_" + Constants.receivedEmail;
    }
    else {
      Constants.chatRoomID = Constants.receivedEmail + "_" + Constants.currentEmail;
    }
    databaseMethods.getChatRoomByID(Constants.chatRoomID).then((val){
      chatRooms = val;
      if(chatRooms.docs.length == 0) {
        Map<String, String> chatRoomMap= {
          "chatRoom_ID" : Constants.chatRoomID,
        };
        databaseMethods.createChatRoom(Constants.chatRoomID, chatRoomMap);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => chat_screen()
        ));
      }
      else {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => chat_screen()
        ));
      }
    });
  }

  Widget usersList() {
    return (allUsers != null) ? ListView.builder(
      primary: false,
      itemCount: allUsers.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        userInfoMap = allUsers.docs[index].data();
        return GestureDetector(
          onTap: (){
            userInfoMap = allUsers.docs[index].data();
            sendToChatScreen(userInfoMap["email"].toString(), userInfoMap["username"].toString());
          },
          child: Tile(
            username: userInfoMap["username"].toString(),
            email: userInfoMap["email"].toString(),
          ),
        );
      },
    ) : Container();
  }

  signMeOut(){
    authMethods.signOut().then((val) {
      //print("${val.uid}");

      Constants.signedInState = false;
      Constants.currentEmail = "";
      Constants.currentUsername = "";

      HelperFunctions.saveUserNameSharedPreference("");
      HelperFunctions.saveUserEmailSharedPreference("");
      HelperFunctions.saveUserLoggedInSharedPreference(false);

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Authenticate()
      ));


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllUsers();
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/chat_app_logo.png", height: 30,),
        brightness: Brightness.dark,
        actions: [
          GestureDetector(
            onTap: (){
              signMeOut();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
                child: Icon(Icons.logout)
            ),
          )
        ],
      ),
      body: Container(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children : [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xff525252),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            Container(
                              padding: EdgeInsets.only(bottom: 10, top: 5),
                              child: Text("Signed In as,", style: simpleTextStyle(),),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                child: Text(Constants.currentUsername, style: currentUsernameTextStyle())),
                            Container(
                                padding: EdgeInsets.only(bottom: 18, top: 2),
                                child: Text("Email : " + Constants.currentEmail, style: buttonTextStyle(),)),
                          ]
                      ),
                    ),
                    usersList(),
                  ]
              ),
            ),
          ),
        ),
      )
    );
  }
}

class Tile extends StatelessWidget {
  final String username, email;
  Tile({this.username, this.email});

  _chat_homeState chat_home_instance = new _chat_homeState();

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: buttonTextStyle()),
                  Text(email, style: simpleTextStyle()),
                ]
            ),
          ),
        Divider(
          color: Color(0xFF454545),
          thickness: 1,
        ),
      ]
    );
  }
}