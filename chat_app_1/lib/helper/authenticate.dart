import 'package:chat_app_1/views/chat_home.dart';
import 'package:chat_app_1/views/sign_in.dart';
import 'package:chat_app_1/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_1/services/auth.dart';

import 'constants.dart';
import 'helperFunctions.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }  

  @override
  void initState() {
    // TODO: implement initState

    HelperFunctions.getUserLoggedInSharedPreference().then((signedInState){
      if( (signedInState != null) && (signedInState != false) ) {
        HelperFunctions.getUserNameSharedPreference().then((username) {
          HelperFunctions.getUserEmailSharedPreference().then((email) {
            setState(() {
              Constants.signedInState = signedInState;
              Constants.currentUsername = username;
              Constants.currentEmail = email;
              print("State : " + Constants.signedInState.toString());
              print("Email : " + Constants.currentEmail);
              print("Username : " + Constants.currentUsername);
            });
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    if( Constants.signedInState ) {
      return chat_home();
    }
    else if(showSignIn) {
      return SignIn(toggleView);
    }
    else {
      return SignUp(toggleView);
    }

  }
}