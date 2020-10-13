import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Tasks/constants/constants.dart';
import 'package:provider/provider.dart';

var displayText = TextStyle(
    color: Colors.lightBlueAccent,
    fontSize: 50,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w900);

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({this.hint, this.icon, this.obscure, this.fieldnumber});
  final String hint;
  final Icon icon;
  final bool obscure;
  final int fieldnumber;

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: hint,
          filled: true,
          prefixIcon: icon,
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white)),
        ),
        onChanged: (value) {
          switch (fieldnumber) {
            case 1:
              textfieldName = value;
              break;
            case 2:
              textfieldEmail = value;
              break;
            case 3:
              textfieldPassword = value;
          }
        });
  }
}

class FlatRoundedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final FaIcon signinpref;
  final bool hasIcon;
  final int icon;
  FlatRoundedButton(
      {this.title, this.icon, this.onPressed, this.hasIcon, this.signinpref});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: icon == 0
          ? Colors.indigo[900]
          : icon == 1
              ? Colors.blue[900]
              : Colors.blue[600],
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        minWidth: 370.0,
        height: 42.0,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'BalooBhai2',
                  fontWeight: FontWeight.w900),
            ),
            hasIcon
                ? SizedBox(width: 15)
                : SizedBox(
                    width: 0,
                  ),
            hasIcon ? signinpref : SizedBox(width: 0),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryTitle, tasks;
  final FaIcon icon;
  CategoryCard({this.categoryTitle, this.tasks, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            SizedBox(height: 25),
            Text(
              categoryTitle,
              style: TextStyle(
                  fontFamily: 'BalooBhai2',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            // Text(
            //   tasks,
            //   style: TextStyle(
            //       fontFamily: 'BalooBhai2',
            //       fontSize: 12,
            //       fontWeight: FontWeight.w400),
            // ),
          ],
        ),
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final String taskText, taskID, category;
  final bool taskDone;
  final BuildContext parentContext;
  TaskTile(
      {this.taskText,
      this.taskDone,
      this.taskID,
      this.category,
      @required this.parentContext});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.taskDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("job-${widget.taskID}"),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Center(
              child: Text(
                "Delete",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Center(
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Text(
                "Delete",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Center(
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
      ),
      // direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        tasksMethods.deleteTask(
            widget.taskID, widget.category, widget.parentContext);
      },
      child: Card(
        child: RaisedButton(
          onPressed: () {},
          onLongPress: () {
            return showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return EditTask(
                    taskID: widget.taskID,
                    initialText: widget.taskText,
                    uid: Constants.myUid,
                    category: widget.category,
                  );
                });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.taskText,
                    maxLines: 20,
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600,
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
                Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                        if (isChecked == false) {
                          tasksMethods.setIsDoneToFalse(
                              widget.taskID, widget.category, context);
                        } else {
                          tasksMethods.setIsDoneToTrue(widget.taskID,
                              widget.category, widget.parentContext);
                        }
                        isChecked = !isChecked;
                        // initializeTasksScreen(Constants.myUid, widget.category);
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTask extends StatefulWidget {
  final String category, uid;
  final BuildContext parentContext;
  AddTask(
      {@required this.category,
      @required this.uid,
      @required this.parentContext});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String task = "";
  Map<String, dynamic> taskMap = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF00426B),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add ${widget.category}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: "BalooBhai2",
                fontWeight: FontWeight.w600,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              // maxLines: 3,
              onChanged: (value) {
                setState(() {
                  task = value;
                });
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatRoundedButton(
                title: "Add",
                hasIcon: false,
                onPressed: () {
                  String taskID =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  if (task.isNotEmpty) {
                    // Provider.of<Data>(context).changeTask();
                    taskMap = {
                      "Task": task,
                      "isDone": false,
                      "Time": DateTime.now(),
                      "uid": taskID
                    };
                    tasksMethods.createNewTask(Constants.myUid, widget.category,
                        taskID, taskMap, widget.parentContext);
                    setState(() {
                      task = "";

                      Navigator.pop(context);

                      // initializeTasksScreen(Constants.myUid, widget.category);
                    });
                  } else {
                    Navigator.pop(context);
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Task Field is left empty!",
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text(
                                "Add a task. You cannot leave the task field empty"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}

class EditTask extends StatefulWidget {
  final String category, uid, initialText, taskID;
  EditTask(
      {@required this.category,
      @required this.uid,
      this.taskID,
      this.initialText});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  String task = "";
  Map<String, dynamic> taskMap = {};
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF00426B),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Edit ${widget.category}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: "BalooBhai2",
                fontWeight: FontWeight.w600,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              // maxLines: 3,
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  task = value;
                });
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatRoundedButton(
                title: "Edit",
                hasIcon: false,
                onPressed: () {
                  if (task.isNotEmpty) {
                    // Provider.of<Data>(context).changeTask();

                    tasksMethods.editTaskText(
                        Constants.myUid, widget.category, widget.taskID, task);
                    setState(() {
                      task = "";

                      Navigator.pop(context);

                      // initializeTasksScreen(Constants.myUid, widget.category);
                    });
                  } else {
                    Navigator.pop(context);
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Task Field is left empty!",
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text(
                                "You need to edit the task. You cannot leave the task field empty"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}

class ShowAlert extends StatelessWidget {
  final String textTitle, textDesc;
  ShowAlert({this.textTitle, this.textDesc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        textTitle,
        style: TextStyle(color: Colors.red),
      ),
      content: Text(textDesc),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
      ],
    );
  }
}

class MySignature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Naha's codebase",
                  style: TextStyle(
                      fontFamily: 'BalooBhai2',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      fontSize: 18,
                      color: Colors.black),
                ),
                SizedBox(width: 5),
                Icon(Icons.copyright),
                SizedBox(width: 5),
                Text(
                  "2020",
                  style: TextStyle(
                      fontFamily: 'BalooBhai2',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            Text(
              "App developer Arunesh Naha",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'BalooBhai2',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  final String title, name;
  EditProfile({@required this.title, this.name});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "";
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF00426B),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Edit ${widget.title}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: "BalooBhai2",
                fontWeight: FontWeight.w600,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              // maxLines: 3,
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatRoundedButton(
                title: "Edit",
                hasIcon: false,
                onPressed: () {
                  if (name.isNotEmpty) {
                    // Provider.of<Data>(context).changeTask();

                    if (widget.title == "Username") {
                      editProfileName(Constants.myUid, name);
                    }
                    if (widget.title == "Description") {
                      editProfileDesc(Constants.myUid, name);
                    }
                    if (widget.title == "Email") {
                      editProfileMail(Constants.myUid, name);
                    }
                    setState(() {
                      name = "";

                      Navigator.pop(context);

                      // initializeTasksScreen(Constants.myUid, widget.category);
                    });
                  } else {
                    Navigator.pop(context);
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "A Field is left empty!",
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text(
                                "You need to edit the detail. You cannot leave the detail field empty"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
