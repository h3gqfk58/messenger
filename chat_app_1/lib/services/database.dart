import 'package:chat_app_1/helper/constants.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods{

  Future<QuerySnapshot<Object>> getUsers() async {
    String currentEmail = await HelperFunctions.getUserEmailSharedPreference();
    return await FirebaseFirestore.instance.collection("users").where("email", isNotEqualTo: Constants.currentEmail).get();
  }

  Future<QuerySnapshot<Object>> getUsersByEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot<Object>> getChatRoomByID(String chatRoomID) async {
    return await FirebaseFirestore.instance.collection("chatRooms").where("chatRoom_ID", isEqualTo: chatRoomID).get();
  }

  createChatRoom(String chatRoomID, chatRoom_Map) {
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomID).set(chatRoom_Map).catchError((e) {
      print(e.toString());
    });
    Map<String, dynamic> chatsMap= {
      "by" : "system",
      "message" : "Chat Room Created",
      "time" : DateTime.now(),
    };
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomID).collection("chats").doc(DateTime.now().toString()).set(chatsMap).catchError((e) {
      print(e.toString());
    });
  }

  addMessage(String chatRoomID, chatMap) {
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomID).collection("chats").doc(DateTime.now().toString()).set(chatMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot<Object>> getChats(String chatRoomID) async {
    return await FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomID).collection("chats").where("time", isNotEqualTo: "0").get();
  }

  /*createChatRoom(String chatRoom_ID, chatRoom_Map) {
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoom_ID).set(chatRoom_Map).catchError((e){
      print(e.toString());
    });
  }*/
}