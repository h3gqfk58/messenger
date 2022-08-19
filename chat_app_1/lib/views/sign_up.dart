import 'package:chat_app_1/helper/authenticate.dart';
import 'package:chat_app_1/helper/constants.dart';
import 'package:chat_app_1/helper/helperFunctions.dart';
import 'package:chat_app_1/services/auth.dart';
import 'package:chat_app_1/services/database.dart';
import 'package:chat_app_1/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chat_home.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  String errorText = "";

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()) {

      Constants.currentUsername = usernameTextEditingController.text;
      Constants.currentEmail = emailTextEditingController.text;
      String password = passwordTextEditingController.text;

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(Constants.currentEmail, password).then((val) {
        print("$val");
        if(val != null) {
          Map<String, String> userInfoMap = {
            "username" : Constants.currentUsername,
            "email" : Constants.currentEmail
          };
          databaseMethods.uploadUserInfo(userInfoMap);

          Constants.signedInState = true;
          HelperFunctions.saveUserLoggedInSharedPreference(Constants.signedInState);
          HelperFunctions.saveUserNameSharedPreference(Constants.currentUsername);
          HelperFunctions.saveUserEmailSharedPreference(Constants.currentEmail);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => chat_home()
          ));
        }
        else {
          setState(() {
            isLoading = false;
            errorText = "Sorry, Something went wrong";
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
                        controller: usernameTextEditingController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Username")
                    ),
                    TextFormField(
                        validator: (val){
                          return (val.length<2) ? "Invalid Email" : null;
                        },
                        controller: emailTextEditingController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Email")
                    ),
                    TextFormField(
                      obscureText: true,
                        validator: (val){
                          return (val.length<6) ? "Invalid Password" : null;
                        },
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
                onTap: (){
                  signMeUp();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  alignment: Alignment.center,
                  child: Text("Sign Up", style: buttonTextStyle(),),
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
                  Text("Already have an account ?   ", style: simpleTextStyle(),),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sign In", style: simpleUnderlineTextStyle(),)
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