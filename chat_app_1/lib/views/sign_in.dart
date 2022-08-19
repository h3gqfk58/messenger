import 'package:chat_app_1/helper/authenticate.dart';
import 'package:chat_app_1/helper/constants.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:chat_app_1/services/auth.dart';
import 'package:chat_app_1/services/database.dart';
import 'package:chat_app_1/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chat_home.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isLoading = false;
  String errorText = "";


  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot currentUser;
  Map<dynamic, dynamic> userInfoMap;

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeIn(){
    setState(() {
      errorText = "";
    });
    if(formKey.currentState.validate()) {

      Constants.currentUsername = "";
      Constants.currentEmail = emailTextEditingController.text;
      String password = passwordTextEditingController.text;

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(Constants.currentEmail, password).then((val) {
        print("$val");
        if(val != null) {

          try{
            databaseMethods.getUsersByEmail(Constants.currentEmail).then((val){
              if(val != null) {
                setState(() {
                  currentUser = val;
                  userInfoMap = currentUser.docs[0].data();

                  Constants.currentUsername = userInfoMap["username"].toString();
                  print("Current users : " + currentUser.toString());
                  print("username : " + Constants.currentUsername);
                  print("Email : " + Constants.currentEmail);

                  Constants.signedInState = true;
                  HelperFunctions.saveUserLoggedInSharedPreference(Constants.signedInState);
                  HelperFunctions.saveUserEmailSharedPreference(Constants.currentEmail);
                  HelperFunctions.saveUserNameSharedPreference(Constants.currentUsername);
                });
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => chat_home()
                ));
              }
            });
          }catch(e) {
            print(e);
          }
        }
        else {
          setState(() {
            isLoading = false;
            errorText = "Invalid Email and Password Combination";
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val){
                          return (val.length<2) ? "Invalid Username" : null;
                        },
                        controller: emailTextEditingController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Email")
                    ),
                    TextFormField(
                        validator: (val){
                          return (val.length<6) ? "Invalid Password" : null;
                        },
                        obscureText: true,
                        controller: passwordTextEditingController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Password")
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              if(errorText.length > 0) Text(errorText, style: errorTextStyle(),),
              SizedBox(height: 25,),
              GestureDetector(
                onTap: () {
                  signMeIn();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  alignment: Alignment.center,
                  child: Text("Sign In", style: buttonTextStyle(),),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account ?   ", style: simpleTextStyle(),),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sign Up", style: simpleUnderlineTextStyle(),)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}