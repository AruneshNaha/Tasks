import 'package:flutter/material.dart';
import 'package:Tasks/widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/Todo.png",
                      height: 100,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Tasks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 80,
                          fontWeight: FontWeight.w700,
                          color: Colors.lightBlueAccent),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 80,
                // ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Hi! I am Arunesh Naha, the developer of this app. This is just a demo todo application made by me. Hope you enjoy this application well",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "BalooBhai2",
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                          "In case you have any problem using this app, you may mail me at aruneshnaha18@gmail.com or you may directly ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "BalooBhai2",
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      Text("Or contact me on +91 9830590554",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "BalooBhai2",
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      Container(
                        color: Colors.yellow,
                        child: Text(
                            "Important Note: In order to delete a particular task, swipe that task left or right. In order to edit the task, press and hold the task long and you can edit it.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "BalooBhai2",
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                MySignature()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
