import 'package:chat_app_1/helper/authenticate.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:chat_app_1/views/chat_home.dart';
import 'package:chat_app_1/views/sign_in.dart';
import 'package:chat_app_1/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }


}
