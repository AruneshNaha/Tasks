import 'package:Tasks/helperFunctions/helperFunctions.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

bool dark = false;
Color themeColor;
String textfieldEmail = "", textfieldName = "", textfieldPassword = "";
QuerySnapshot snapshotUserInfo;
DatabaseMethods databaseMethods = new DatabaseMethods();

int taskIsDoneLength = 0, taskIsNotDoneLength = 0, totalTasks = 0;

//Color(0xff444444)
TasksMethods tasksMethods = TasksMethods();
List<String> categories = [
  'Misc',
  'Work',
  'Travel',
  'Music',
  'Study',
  'Home',
  'Painting',
  'Shopping'
];

Future<int> calculatetasknumber(String uid, taskCategory) async {
  return await tasksMethods.getNumberofTasks(uid, taskCategory);
}

List<String> tasks = [
  '0 tasks',
  '0 tasks',
  '0 tasks',
  '0 tasks',
  '0 tasks',
  '0 tasks',
  '0 tasks',
  '0 tasks',
];

Future<int> getTasks(String uid, taskCategory) async {
  int task = await calculatetasknumber(uid, taskCategory);
  return task;
}

class TasksMethods {
  QuerySnapshot snapshots;

  editTaskText(
      String uid, String taskCategory, String taskID, String taskText) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(taskCategory)
        .doc(taskID)
        .update({"Task": taskText})
        .then((value) => print("Success in editing text"))
        .catchError((e) {
          print("Error: ${e.toString()}");
        });
  }

  deleteAllTasks(String taskCategory, BuildContext context) async {
    List<String> taskID = [];

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(taskCategory)
        .get()
        .then((querySnapShot) {
      querySnapShot.documents.forEach((result) {
        taskID.add(result.data()["uid"]);
      });
    });

    for (var task in taskID) {
      await FirebaseFirestore.instance
        ..collection("user")
            .doc(Constants.myUid)
            .collection(taskCategory)
            .doc(task)
            .delete()
            .then((value) {
          print("Deletion success!");
          Provider.of<ChangeTaskData>(context).changeTotTaskNumber(totalTasks);
        }).catchError((e) {
          print("${e.toString()}");
        });
    }
  }

  markAllUndone(String taskCategory, BuildContext context) async {
    List<String> taskID = [];

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(taskCategory)
        .get()
        .then((querySnapShot) {
      querySnapShot.documents.forEach((result) {
        taskID.add(result.data()["uid"]);
      });
    });

    for (var task in taskID) {
      setIsDoneToFalse(task, taskCategory, context);
    }
  }

  markAllDone(String taskCategory, BuildContext context) async {
    List<String> taskID = [];

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(taskCategory)
        .get()
        .then((querySnapShot) {
      querySnapShot.documents.forEach((result) {
        taskID.add(result.data()["uid"]);
      });
    });

    for (var task in taskID) {
      setIsDoneToTrue(task, taskCategory, context);
    }
  }

  createNewTask(String uid, String taskCategory, String taskID, Map task,
      BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection(taskCategory)
        .doc(taskID)
        .set(task)
        .then((_) {
      print("Task Creation success!");
      Provider.of<ChangeTaskData>(context).changeTotTaskNumber(totalTasks);
    }).catchError((e) {
      print("Error in Adding task:${e.toString()}");
    });
  }

  Future<bool> categoryHasTask(String uid, taskCategory) async {
    // snapshots = await FirebaseFirestore.instance
    //     .collection("user")
    //     .where("id", isEqualTo: uid)
    //     .getDocuments();

    // databaseMethods.getUserByUserUid(uid).then((val) {
    //   snapshots = val;
    // });

    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection(taskCategory)
        .getDocuments()
        .then((value) => {snapshots = value});

    if (snapshots.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> getNumberofTasks(String uid, taskCategory) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection(taskCategory)
        .get()
        .then((value) => {snapshots = value});

    totalTasks = snapshots.docs.length;

    return snapshots.docs.length;
  }

  Future<int> getNumberDoneTasks(String uid, taskCategory) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection(taskCategory)
        .where("isDone", isEqualTo: true)
        .get()
        .then((value) => {snapshots = value});

    totalTasks = snapshots.docs.length;

    return snapshots.docs.length;
  }

  Future<int> getNumberNotDoneTasks(String uid, taskCategory) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection(taskCategory)
        .where("isDone", isEqualTo: false)
        .get()
        .then((value) => {snapshots = value});

    totalTasks = snapshots.docs.length;

    return snapshots.docs.length;
  }

  void getTasks(String taskCategory) async {
    await for (var snapshots in FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(taskCategory)
        .snapshots()) {
      for (var message in snapshots.docs) {
        print(message.data());
      }
    }
  }

  void setIsDoneToTrue(String id, category, BuildContext context) async {
    print("Document id:" + id);
    print("Category:" + category);

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(category)
        .doc(id)
        .update({"isDone": true}).then((value) {
      Provider.of<ChangeTaskData>(context)
          .changeDoneTaskNumber(taskIsDoneLength);
      Provider.of<ChangeTaskData>(context)
          .changeDoneTaskNumber(taskIsNotDoneLength);
    });
  }

  void setIsDoneToFalse(String id, category, BuildContext context) async {
    print("Document id:" + id);
    print("Category:" + category);

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(category)
        .doc(id)
        .updateData({"isDone": false}).then((value) {
      Provider.of<ChangeTaskData>(context)
          .changeDoneTaskNumber(taskIsNotDoneLength);
      Provider.of<ChangeTaskData>(context)
          .changeDoneTaskNumber(taskIsDoneLength);
    }).catchError((e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ShowAlert(
              textDesc: "${e.toString()}",
            );
          });
    });
  }

  void deleteTask(String id, String category, BuildContext context) async {
    print("Document id:" + id);
    print("Category:" + category);

    await FirebaseFirestore.instance
        .collection("user")
        .doc(Constants.myUid)
        .collection(category)
        .doc(id)
        .delete()
        .then((_) {
      print("Deletion Success!");
      Provider.of<ChangeTaskData>(context).changeTotTaskNumber(totalTasks);
    }).catchError((e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ShowAlert(
              textDesc: "${e.toString()}",
            );
          });
    });
  }
}

class TaskStreamDone extends StatefulWidget {
  final String taskCategory;
  final BuildContext parentContext;
  TaskStreamDone({this.taskCategory, @required this.parentContext});

  @override
  _TaskStreamDoneState createState() => _TaskStreamDoneState();
}

class _TaskStreamDoneState extends State<TaskStreamDone> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(Constants.myUid)
          .collection(widget.taskCategory)
          .orderBy('Time')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final tasks = snapshot.data.docs.reversed;
        List<TaskTile> taskWidgets = [];
        for (var task in tasks) {
          String taskText = task.data()['Task'];
          bool taskDone = task.data()['isDone'];
          String taskID = task.data()["uid"];
          print(taskText + "is Checked" + "$taskDone");

          final listTask = TaskTile(
            taskText: taskText,
            taskDone: taskDone,
            taskID: taskID,
            category: widget.taskCategory,
            parentContext: widget.parentContext,
          );
          if (taskDone) {
            taskWidgets.add(listTask);
            // taskIsDoneLength = taskWidgets.length;
            // Provider.of<ChangeTaskData>(context)
            //     .changeNotdoneTaskNumber(taskIsNotDoneLength);
            // Provider.of<ChangeTaskData>(context)
            //     .changeTotTaskNumber(taskIsNotDoneLength + taskIsDoneLength);
          }
        }
        return Column(
          children: taskWidgets,
        );
      },
    );
  }
}

class TaskStreamNotDone extends StatefulWidget {
  final String taskCategory;
  final BuildContext parentContext;
  TaskStreamNotDone({this.taskCategory, @required this.parentContext});

  @override
  _TaskStreamNotDoneState createState() => _TaskStreamNotDoneState();
}

class _TaskStreamNotDoneState extends State<TaskStreamNotDone> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(Constants.myUid)
          .collection(widget.taskCategory)
          .orderBy('Time')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final tasks = snapshot.data.docs.reversed;
        totalTasks = snapshot.data.docs.length;
        List<TaskTile> taskWidgets = [];

        for (var task in tasks) {
          String taskText = task.data()['Task'];
          bool taskDone = task.data()['isDone'];
          String taskID = task.data()["uid"];
          print(taskText + " is Checked to " + "$taskDone");

          final listTask = TaskTile(
            taskText: taskText,
            taskDone: taskDone,
            taskID: taskID,
            category: widget.taskCategory,
            parentContext: widget.parentContext,
          );
          if (!taskDone) {
            taskWidgets.add(listTask);
            // taskIsNotDoneLength = taskWidgets.length;
            // Provider.of<ChangeTaskData>(context)
            //     .changeTotTaskNumber(taskIsNotDoneLength + taskIsDoneLength);
            // Provider.of<ChangeTaskData>(context)
            //     .changeNotdoneTaskNumber(taskIsNotDoneLength);
          }
        }
        return Column(
          children: taskWidgets,
        );
      },
    );
  }
}

// intializeTasksNumber(String uid, String category) async {
//   QuerySnapshot snapshots;
//   await FirebaseFirestore.instance
//       .collection("user")
//       .doc(uid)
//       .collection(category)
//       .getDocuments()
//       .then((value) => snapshots = value);

//   totalTasks = snapshots.docs.length;
// }

class ChangeTaskData extends ChangeNotifier {
  // final String taskCategory;
  // Data({@required this.taskCategory});

  int getTotalTasks = totalTasks;
  int taskDone = taskIsDoneLength;
  int taskNotDone = taskIsNotDoneLength;

  void changeTotTaskNumber(int tottask) {
    getTotalTasks = tottask;

    notifyListeners();
  }

  void changeDoneTaskNumber(int donetasks) {
    taskIsDoneLength = donetasks;
    notifyListeners();
  }

  void changeNotdoneTaskNumber(int notdonetasks) {
    taskIsNotDoneLength = notdonetasks;
    notifyListeners();
  }
}

List<FaIcon> categoryIcon = [
  FaIcon(
    FontAwesomeIcons.list,
    size: 30,
    color: Colors.yellow[900],
  ),
  FaIcon(
    FontAwesomeIcons.building,
    size: 30,
    color: Colors.blue,
  ),
  FaIcon(
    FontAwesomeIcons.plane,
    size: 30,
    color: Colors.red,
  ),
  FaIcon(
    FontAwesomeIcons.headphones,
    size: 30,
    color: Colors.yellow[900],
  ),
  FaIcon(
    FontAwesomeIcons.book,
    size: 30,
    color: Colors.orange,
  ),
  FaIcon(
    FontAwesomeIcons.home,
    size: 30,
    color: Colors.green,
  ),
  FaIcon(
    FontAwesomeIcons.paintBrush,
    size: 30,
    color: Colors.pink,
  ),
  FaIcon(
    FontAwesomeIcons.shoppingCart,
    size: 30,
    color: Colors.lightBlueAccent,
  ),
];

List<String> choices = [
  "Mark all as done",
  "Mark all as undone",
  "Delete All",
  "About"
];

class Constants {
  static String myName = "";
  static String myEmail = "";
  static String myUid = "";
}

editProfileName(String uid, String profileName) async {
  await FirebaseFirestore.instance
      .collection("user")
      .doc(Constants.myUid)
      .update({"name": profileName}).then((value) {
    print("Success in editing profileName");
    saveLocalData(Constants.myEmail, Constants.myUid);
  }).catchError((e) {
    print("Error: ${e.toString()}");
  });
}

editProfileDesc(String uid, String profileDesc) async {
  await FirebaseFirestore.instance
      .collection("user")
      .doc(Constants.myUid)
      .update({"desc": profileDesc}).then((value) {
    print("Success in editing Profile description");
    saveLocalData(Constants.myEmail, Constants.myUid);
  }).catchError((e) {
    print("Error: ${e.toString()}");
  });
}

editProfileMail(String uid, String profileMail) async {
  await FirebaseFirestore.instance
      .collection("user")
      .doc(Constants.myUid)
      .update({"email": profileMail}).then((value) {
    print("Success in editing profile email");
    saveLocalData(profileMail, Constants.myUid);
  }).catchError((e) {
    print("Error: ${e.toString()}");
  });
}

saveLocalData(String email, String uid) async {
  await databaseMethods.getUserByUserUid(uid).then((val) {
    snapshotUserInfo = val;
  });

  String name, fetchuid, docID;
  await HelperFunctions.saveUserEmailSharedPreference(email);

  Map<String, String> userInfoMap = {
    "name": "Anomymous",
    "email": email,
    "id": uid.toString(),
    "desc": ""
  };

  print("Snapshot data is ${snapshotUserInfo.docs}");

  if (snapshotUserInfo.docs.length == 0) {
    docID = uid.toString();
    await FirebaseFirestore.instance
        .collection("user")
        .doc(docID)
        .set(userInfoMap);
  } else {
    name = await snapshotUserInfo.docs[0].data()["name"];
    fetchuid = await snapshotUserInfo.docs[0].data()["id"];
    docID = snapshotUserInfo.docs[0].id;

    userInfoMap = {"name": name, "email": email, "id": uid.toString()};

    print("User uid: $fetchuid");
    print("UserName: $name");

    if (fetchuid == null) {
      print("UID in if block:$uid");
      print("Document ID: $docID");

      await FirebaseFirestore.instance
          .collection("user")
          .doc(docID)
          .set(userInfoMap);
    }
  }

  await HelperFunctions.saveUserNameSharedPreference(name);
  await HelperFunctions.saveUserUidSharedPreference(uid);
  await HelperFunctions.saveUserLoggedInSharedPreference(true);
  Constants.myName = name;
  Constants.myEmail = email;
  Constants.myUid = uid;
}

getLocalData() async {
  Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
  Constants.myUid = await HelperFunctions.getUserUidSharedPreference();
}

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("user")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String email) async {
    return await Firestore.instance
        .collection("user")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  getUserByUserUid(String uid) async {
    return await Firestore.instance
        .collection("user")
        .where("id", isEqualTo: uid)
        .getDocuments();
  }

  uploadUserInfo(Map userInfo) {
    Firestore.instance
        .collection("user")
        .add(userInfo)
        .then((value) => print("User info uploaded!"));
  }
}
