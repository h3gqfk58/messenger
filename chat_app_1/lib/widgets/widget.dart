import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/chat_app_logo.png", height: 30,),
    brightness: Brightness.dark,
  );
}

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54)
      )
  );
}

TextStyle textFieldStyle() {
  return TextStyle(
    color: Colors.white
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 13
  );
}

TextStyle errorTextStyle() {
  return TextStyle(
      color: Colors.red,
      fontSize: 13
  );
}

TextStyle simpleUnderlineTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 13,
      decoration: TextDecoration.underline
  );
}

TextStyle smallTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 10,
  );
}

TextStyle buttonTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 15
  );
}

TextStyle currentUsernameTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 20
  );
}