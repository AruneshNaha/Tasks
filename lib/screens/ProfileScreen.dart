import 'dart:ui';
import 'dart:io';

import 'package:Tasks/constants/constants.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  Image display;
  String username = "", email = "", description = "", imagedownloadurl = "";
  bool showSpinner = false;

  @override
  void initState() {
    getUserDetails();
    initializeProfileScreen();
    getPic();
    super.initState();
  }

  initializeProfileScreen() async {
    await getPic();
  }

  Future getUserDetails() async {
    await databaseMethods.getUserByUserUid(Constants.myUid).then((val) {
      snapshotUserInfo = val;
    });

    String name = await snapshotUserInfo.docs[0].data()["name"];
    String mail = await snapshotUserInfo.docs[0].data()["email"];
    String d = await snapshotUserInfo.docs[0].data()["desc"];

    setState(() {
      username = name;
      email = mail;
      description = d;
    });
  }

  Future getPic() async {
    try {
      String downloadUrl = await FirebaseStorage.instance
          .ref()
          .child("${Constants.myUid}")
          .getDownloadURL();
      setState(() {
        imagedownloadurl = downloadUrl;
        print("Download url is: $imagedownloadurl");
        display = Image.network(
          imagedownloadurl,
          fit: BoxFit.fill,
        );
      });
    } catch (e) {
      print("Error is : ${e.toString()}");
      setState(() {
        imagedownloadurl = "No image";
        display = Image.asset(
          "images/NotLoaded.png",
          fit: BoxFit.fill,
        );
        print("Download url is: $imagedownloadurl");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        imagedownloadurl = "No image";
        display = Image.file(
          _image,
          fit: BoxFit.fill,
        );
        print(_image);
      });
    }

    Future openCamera() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        display = Image.file(
          _image,
          fit: BoxFit.fill,
        );
        print(_image);
      });
    }

    Future uploadPic(BuildContext context) async {
      // String filename = basename(_image.path);
      print(_image.toString());
      if (_image == null) {
        setState(() {
          showSpinner = false;
          return AlertDialog(
            title: Text(
              "Upload error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
                "You didn't choose an image from gallery or click one from camera"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"))
            ],
          );
        });
      } else {
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(Constants.myUid);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        setState(() {
          print("Profile picture uploaded!");
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Profile picture uploaded"),
          ));
          showSpinner = false;
        });
      }
    }

    //TODO: Future getPic

    //TODO: Future delete profile picture

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
            body: Builder(
          builder: (context) => Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 30,
                          ),
                          onPressed: () {
                            openCamera();
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.lightBlueAccent[700],
                          child: ClipOval(
                            child: SizedBox(
                                width: 180, height: 180, child: display),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.image,
                            size: 30,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Username",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontFamily: "BalooBhai2",
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      username,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "BalooBhai2",
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontFamily: "BalooBhai2",
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "BalooBhai2",
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Click on Upload image to upload the selected image",
                      style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.yellow,
                        fontFamily: "BalooBhai2",
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Colors.lightBlueAccent[700],
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: "BalooBhai2",
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.lightBlueAccent[700],
                        onPressed: () {
                          setState(() {
                            showSpinner = true;
                          });
                          uploadPic(context);
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Upload image",
                            style: TextStyle(
                                fontFamily: "BalooBhai2",
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  MySignature()
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class FireStorageService {
  static loadImage(BuildContext context, image) {}
}
