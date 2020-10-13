import 'package:Tasks/constants/constants.dart';
import 'package:Tasks/screens/AboutScreen.dart';
import 'package:Tasks/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  final String tasks, category;
  final FaIcon icon;
  TasksScreen({this.tasks, this.category, this.icon});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TasksMethods tasksMethods = TasksMethods();
  int tasks = 0;
  @override
  void initState() {
    initializeTasksScreen();
    super.initState();
  }

  void initializeTasksScreen() async {
    totalTasks =
        await tasksMethods.getNumberofTasks(Constants.myUid, widget.category);
    // taskIsDoneLength =
    //     await tasksMethods.getNumberDoneTasks(Constants.myUid, widget.category);
    // taskIsNotDoneLength = await tasksMethods.getNumberNotDoneTasks(
    //     Constants.myUid, widget.category);

    print(
        "Total Tasks: $totalTasks Done Tasks: $taskIsDoneLength Not Done Tasks: $taskIsNotDoneLength");

    Provider.of<ChangeTaskData>(context).changeTotTaskNumber(totalTasks);
    // Provider.of<ChangeTaskData>(context).changeDoneTaskNumber(taskIsDoneLength);
    // Provider.of<ChangeTaskData>(context)
    //     .changeNotdoneTaskNumber(taskIsNotDoneLength);

    print(
        "After provider total tasks: ${Provider.of<ChangeTaskData>(context).getTotalTasks}, Done Tasks ${Provider.of<ChangeTaskData>(context).taskDone}, Not done tasks ${Provider.of<ChangeTaskData>(context).taskNotDone} ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent[700],
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      PopupMenuButton(onSelected: (value) {
                        switch (value) {
                          case "Mark all as done":
                            tasksMethods.markAllDone(widget.category, context);
                            break;
                          case "Mark all as undone":
                            tasksMethods.markAllUndone(
                                widget.category, context);
                            break;
                          case "Delete All":
                            tasksMethods.deleteAllTasks(
                                widget.category, context);
                            break;
                          case "About":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutScreen()));
                        }
                      }, itemBuilder: (BuildContext context) {
                        return choices.map((String choices) {
                          return PopupMenuItem<String>(
                            value: choices,
                            child: Text(
                              choices,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList();
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  CircleAvatar(
                    radius: 40.0,
                    child: widget.icon,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightBlue[900],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.category,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                        fontFamily: 'BalooBhai2',
                        color: Colors.white),
                  ),
                  Text(
                    "${Provider.of<ChangeTaskData>(context).getTotalTasks} Tasks",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: 'BalooBhai2',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28)),
              ),
              height: Provider.of<ChangeTaskData>(context).getTotalTasks != 0
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height - 395,
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:
                      //  tasks != 0
                      //     ?
                      ListView(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Done:",
                            style: TextStyle(
                                fontFamily: 'BalooBhai2',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                color: Colors.green),
                          ),
                          SizedBox(width: 6),
                          // Text(
                          //   "${Provider.of<ChangeTaskData>(context).taskDone} Tasks",
                          //   style: TextStyle(
                          //       fontFamily: 'BalooBhai2',
                          //       fontWeight: FontWeight.w600,
                          //       decoration: TextDecoration.none,
                          //       fontSize: 18,
                          //       color: Colors.grey),
                          // ),
                        ],
                      ),
                      TaskStreamDone(
                        taskCategory: widget.category,
                        parentContext: context,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Remaining:",
                            style: TextStyle(
                                fontFamily: 'BalooBhai2',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                color: Colors.redAccent),
                          ),
                          SizedBox(width: 6),
                          // Text(
                          //   "${Provider.of<ChangeTaskData>(context).taskNotDone} Tasks",
                          //   style: TextStyle(
                          //       fontFamily: 'BalooBhai2',
                          //       fontWeight: FontWeight.w600,
                          //       decoration: TextDecoration.none,
                          //       fontSize: 18,
                          //       color: Colors.grey),
                          // ),
                        ],
                      ),
                      TaskStreamNotDone(
                        taskCategory: widget.category,
                        parentContext: context,
                      )
                      // Text("Cleaning car"),
                      // Text("Remaining"),
                      // Text("Cleaning room")
                    ],
                  )
                  // : Center(
                  //     child: Text(
                  //       "No tasks",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           fontFamily: 'BalooBhai2',
                  //           fontWeight: FontWeight.w600,
                  //           decoration: TextDecoration.none,
                  //           fontSize: 40,
                  //           color: Colors.grey[800]),
                  //     ),
                  //   ),
                  ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showModalBottomSheet(
              context: context,
              builder: (BuildContext childContext) {
                return AddTask(
                  uid: Constants.myUid,
                  category: widget.category,
                  parentContext: context,
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
