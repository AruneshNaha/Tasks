import 'package:Tasks/screens/ListScreen.dart';
import 'package:Tasks/screens/login.dart';
import 'package:flutter/material.dart';

import 'helperFunctions/helperFunctions.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLoggedIn = false;

  @override
  void initState() {
    userLoggedIn = false;
    getloggedInState();
    initializeDefault();
    super.initState();
  }

  getloggedInState() async {
    bool pref = await HelperFunctions.getUserLoggedInSharedPreference();
    setState(() {
      userLoggedIn = pref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: userLoggedIn != null
            ? (userLoggedIn ? ListScreen() : LoginScreen())
            : LoginScreen());
  }
}
