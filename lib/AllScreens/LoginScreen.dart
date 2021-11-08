
import 'package:creuse1/AllScreens/registrationScreen.dart';
import 'package:creuse1/AllWidgets/progressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'mainscreen.dart';




class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 35.0,),
                Image(
                  image: AssetImage("images/images/logo.png"),
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1.0,),
                Text(
                  "Login as a Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(

                    children: [
                      SizedBox(height: 1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,

                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,


                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 10.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,

                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,


                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 10.0,),
                      RaisedButton(
                          color: Colors.yellow,
                          textColor: Colors.white,
                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18.0, fontFamily: 'Brand Bold'),
                              ),
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0),
                          ),
                          onPressed: () {
                            if(!emailTextEditingController.text.contains("@")){

                              displayToastMessage("Email address is not valid.", context);
                            }

                            else if(passwordTextEditingController.text.isEmpty ){

                              displayToastMessage("Password is mandatory", context);
                            }

                            else {

                              loginAndAuthenticateUser(context);
                            }


                          }
                      )
                    ],
                  ),

                ),

                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: Text(
                      "Do not have an Account? Register Here."
                  ),
                ),


              ],
            ),
          ),
        )

    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {

    showDialog(
        context: context,
       barrierDismissible: false,
      builder:(BuildContext context){

        return  progressDialog(message: "Authenticating, Please wait...",);
      }

    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)//user creates
        {


      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null){

          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged-in", context);
        }

        else {
          Navigator.pop(context);
           _firebaseAuth.signOut();
           displayToastMessage("Ooops! No record exists for this user. Please create new account. ", context);


          
        }

      } );

    }
    else
    {
      //error occured - display error msg
      Navigator.pop(context);
      displayToastMessage("Error occured, cannot be signed in", context);



    }
  }
  displayToastMessage(String message, BuildContext context){

    Fluttertoast.showToast(msg: message);
  }



}