import 'dart:io';

import 'package:Tasks/authentication/authentication.dart';
import 'package:Tasks/constants/constants.dart';
import 'package:Tasks/helperFunctions/helperFunctions.dart';
import 'package:Tasks/screens/AboutScreen.dart';
import 'package:Tasks/screens/ProfileScreen.dart';
import 'package:Tasks/screens/login.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'TasksScreen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    initializeListScreen(Constants.myUid);
    super.initState();
  }

  void initializeListScreen(String uid) async {
    await getLocalData();
    await categoryTasks();
  }

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

  Future<void> categoryTasks() async {
    for (var i = 0; i < 8; i++) {
      try {
        int num = await calculatetasknumber(Constants.myUid, categories[i]);
        setState(() {
          tasks[i] = "$num Tasks";
        });
      } catch (e) {
        setState(() {
          tasks[i] = "0 Tasks";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Builder(
                builder: (context) => IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.stream,
                    size: 40.0,
                    color: Colors.black87,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
          drawer: OpenDrawer(),
          key: _scaffoldKey,
          body: Container(
            // padding: EdgeInsets.all(30.0),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lists",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 40.0,
                          fontFamily: 'BalooBhai2',
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      itemBuilder: (context, index) => Material(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider<
                                              ChangeTaskData>(
                                            builder: (context) =>
                                                ChangeTaskData(),
                                            child: TasksScreen(
                                              tasks: tasks[index],
                                              category: categories[index],
                                              icon: categoryIcon[index],
                                            ),
                                          )));
                            });
                          },
                          child: CategoryCard(
                            categoryTitle: categories[index],
                            icon: categoryIcon[index],
                            tasks: tasks[index],
                          ),
                        ),
                      ),
                      itemCount: 8,
                    ),
                    SizedBox(height: 40),
                    FlatRoundedButton(
                      title: "Sign out",
                      hasIcon: false,
                      onPressed: () {
                        signout();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                    SizedBox(height: 40),
                    MySignature()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void signout() async {
  await auth.signOut();
  HelperFunctions.saveUserLoggedInSharedPreference(false);
}

class OpenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Profile, Settings, About, Logout
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Tasks",
              style: TextStyle(
                  fontFamily: "BalooBhai2",
                  fontSize: 38,
                  fontWeight: FontWeight.w700),
            ),
            // accountEmail: Text(
            //   "A simple todo app",
            //   style: TextStyle(
            //       fontFamily: "BalooBhai2",
            //       fontSize: 15,
            //       fontWeight: FontWeight.w400),
            // ),
            currentAccountPicture: Material(
              borderRadius: BorderRadius.circular(3000),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange,
                child: Image.asset("images/Todo.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: ListTile(
              title: Text(
                "Profile",
                style: TextStyle(
                    fontFamily: "BalooBhai2",
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          // ListTile(
          //   title: Text("Settings",
          //       style: TextStyle(
          //           fontFamily: "BalooBhai2",
          //           fontSize: 24,
          //           fontWeight: FontWeight.w700)),
          // ),
          // SizedBox(
          //   height: 40,
          // ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutScreen())),
            child: ListTile(
              title: Text("About",
                  style: TextStyle(
                      fontFamily: "BalooBhai2",
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              signout();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: ListTile(
              title: Text("Logout",
                  style: TextStyle(
                      fontFamily: "BalooBhai2",
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Material(
            borderRadius: BorderRadius.circular(500),
            child: InkWell(
              borderRadius: BorderRadius.circular(500),
              splashColor: Colors.black45,
              onTap: () => Navigator.of(context).pop(),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 190,
          ),
          Center(
            child: Text(
              "Tasks app version 2.0.0",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "BalooBhai2",
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
