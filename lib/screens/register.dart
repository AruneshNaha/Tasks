import 'package:Tasks/constants/constants.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'ListScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;

  void errorHandler(String error) {
    setState(() {
      Alert(
        type: AlertType.error,
        context: context,
        desc: error,
        title: "ERROR",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              showSpinner = false;
            },
            width: 120,
          )
        ],
      ).show();
    });
  }

  Future<Null> createNewUser(String email, password, name) async {
    try {
      final newuser = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (newuser.uid != null) {
        Map<String, String> userInfoMap = {
          "name": name,
          "email": email,
          "id": newuser.uid.toString()
        };
        String docID = newuser.uid.toString();

        await FirebaseFirestore.instance
            .collection("user")
            .doc(docID)
            .set(userInfoMap);

        saveLocalData(email, newuser.uid);

        setState(() {
          showSpinner = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListScreen()));
        });
      }
    } catch (e) {
      print("Debug 2 : $e");
      showSpinner = false;
      errorHandler(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: themeColor,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(15),
                child: Image.asset(
                  "images/Todo.png",
                  height: 100,
                ),
              ),
              Center(
                child: Text("Tasks",
                    textAlign: TextAlign.center, style: displayText),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28)),
                    color: Colors.lightBlueAccent,
                  ),
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text("Register now",
                          textAlign: TextAlign.center,
                          style: displayText.copyWith(color: Colors.white)),
                      SizedBox(
                        height: 40,
                      ),
                      TextFieldWidget(
                        hint: "Name",
                        obscure: false,
                        fieldnumber: 1,
                        icon: Icon(Icons.person),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        hint: "Email",
                        obscure: false,
                        fieldnumber: 2,
                        icon: Icon(Icons.mail),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFieldWidget(
                        hint: "Password",
                        obscure: true,
                        fieldnumber: 3,
                        icon: Icon(Icons.lock),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Center(
                          child: FlatRoundedButton(
                        hasIcon: false,
                        onPressed: () {
                          showSpinner = true;
                          createNewUser(
                              textfieldEmail, textfieldPassword, textfieldName);
                        },
                        title: "Register",
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
