import 'dart:io';

import 'package:Tasks/authentication/authentication.dart';
import 'package:Tasks/constants/constants.dart';
import 'package:Tasks/helperFunctions/helperFunctions.dart';
import 'package:Tasks/screens/ListScreen.dart';
import 'package:Tasks/screens/register.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);
  print('Initialized default app $app');
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to exit the app?"),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No")),
          FlatButton(
              onPressed: () {
                exit(0);
              },
              child: Text("Yes"))
        ],
      ),
    );
  }

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
              showspinner = false;
            },
            width: 120,
          )
        ],
      ).show();
    });
  }

  @override
  void initState() {
    initializeDefault();
    super.initState();
  }

  void signInAnonymously() async {
    try {
      var authResult;
      final auth = FirebaseAuth.instance;
      authResult = await auth.signInAnonymously();
      print("${authResult.user.uid}");
      if (authResult.user.uid != null) {
        print("Push to next screen");

        HelperFunctions.saveUserNameSharedPreference("Anonymous");
        HelperFunctions.saveUserEmailSharedPreference("Anonymous email");
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Constants.myEmail = "Anonymous email";
        Constants.myName = "Anomymous";
        Constants.myUid = authResult.user.uid;
        setState(() {
          saveLocalData(Constants.myEmail, Constants.myUid);
          showspinner = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListScreen()));
        });
      }
    } catch (e) {
      print("${e.toString()}");
      setState(() {
        showspinner = false;
      });
      errorHandler(e.toString());
    }
  }

  Future<Null> signinWithGoogle() async {
    try {
      GoogleSignIn googleuser = GoogleSignIn();
      bool isLoggedIn;

      isLoggedIn = await googleuser.isSignedIn();

      final GoogleSignInAccount user = await googleuser.signIn();
      final GoogleSignInAuthentication googleAuth = await user.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final firebaseUser = (await auth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection("user")
            .where("id", isEqualTo: firebaseUser.uid)
            .get();
        isLoggedIn = true;

        print("Rendered log in to true!");

        if (isLoggedIn) {
          print("Push to next screen");

          HelperFunctions.saveUserNameSharedPreference(
              firebaseUser.displayName);
          HelperFunctions.saveUserEmailSharedPreference(firebaseUser.email);
          HelperFunctions.saveUserLoggedInSharedPreference(true);

          Constants.myEmail = firebaseUser.email;
          Constants.myName = firebaseUser.displayName;
          Constants.myUid = firebaseUser.uid;
          setState(() {
            saveLocalData(firebaseUser.email, firebaseUser.uid);
            showspinner = false;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListScreen()));
          });
        }

        List<QueryDocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          if (isLoggedIn) {
            FirebaseFirestore.instance
                .collection("user")
                .doc(firebaseUser.uid)
                .setData({
              "email": firebaseUser.email,
              "name": firebaseUser.displayName,
              "id": firebaseUser.uid
            });

            print("Logged in data stored in firebase");
          }
        }
      }
    } catch (e) {
      showspinner = false;
      print("Debug 2 : $e");
      errorHandler(e.toString());
    }
  }

  Future<Null> signInWithEmail(String email, password) async {
    try {
      final newuser = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (newuser.uid != null) {
        saveLocalData(email, newuser.uid);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListScreen()));
        setState(() {
          showspinner = false;
        });
      }
    } catch (e) {
      print("Debug 2 : $e");
      showspinner = false;
      errorHandler(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showspinner,
          child: Scaffold(
            backgroundColor: themeColor,
            body: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FlatButton(
                //     onPressed: () {
                //       setState(() {
                //         dark = !dark;
                //         dark
                //             ? themeColor = Color(0xff444444)
                //             : themeColor = Colors.white;
                //       });
                //     },
                //     child: dark
                //         ? Text("Switch to light theme")
                //         : Text("Switch to dark theme")),
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
                Container(
                  // height: MediaQuery.of(context).size.height - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28)),
                    color: Colors.lightBlueAccent,
                  ),
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text("Sign in",
                          textAlign: TextAlign.center,
                          style: displayText.copyWith(color: Colors.white)),
                      SizedBox(
                        height: 40,
                      ),
                      TextFieldWidget(
                        hint: "Email",
                        fieldnumber: 2,
                        obscure: false,
                        icon: Icon(Icons.mail),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFieldWidget(
                        hint: "Password",
                        fieldnumber: 3,
                        obscure: true,
                        icon: Icon(Icons.lock),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Center(
                          child: FlatRoundedButton(
                        icon: 0,
                        hasIcon: false,
                        onPressed: () {
                          setState(() {
                            showspinner = true;
                          });
                          signInWithEmail(textfieldEmail, textfieldPassword);
                        },
                        title: "Sign in",
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      // Center(
                      //     child: FlatRoundedButton(
                      //   hasIcon: true,
                      //   icon: 1,
                      //   signinpref: FaIcon(FontAwesomeIcons.facebook,
                      //       color: Colors.white),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => ListScreen()));
                      //   },
                      //   title: "Sign in with Facebook",
                      // )),
                      // SizedBox(height: 20),
                      Center(
                          child: FlatRoundedButton(
                        icon: 2,
                        signinpref: FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        hasIcon: true,
                        onPressed: () {
                          setState(() {
                            showspinner = !showspinner;
                          });
                          signinWithGoogle();
                        },
                        title: "Sign in with Google",
                      )),
                      SizedBox(height: 10),

                      SizedBox(height: 10),
                      Center(
                          child: FlatRoundedButton(
                        icon: 0,
                        hasIcon: false,
                        onPressed: () {
                          signInAnonymously();
                          setState(() {
                            showspinner = true;
                          });
                        },
                        title: "Sign in anonymously",
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MySignature()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
