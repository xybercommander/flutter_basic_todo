import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helper/database_helper.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {    
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
    print(_taskList);  
  }



  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
              ),
            ),
            subtitle: Text(
              '${_dateFormatter.format(task.date)} • ${task.priority}',
              style: TextStyle(
                fontSize: 15,
                decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
              ),
            ),
            trailing: Checkbox(
              onChanged: (value) {                
                // value == true ? task.status = 1 : task.status = 0;
                task.status = value ? 1 : 0; // same as the above statement
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              value: true,
              activeColor: Theme.of(context).primaryColor,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(task: task))),
          ),
          Divider() // TODO remove the last divider
        ],
      ),
    );
  }


  // UI OF THE \TODO LIST
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {    

          // TODO SNAPSHOT IS SHOWING NULL
          if(!snapshot.hasData || snapshot.data.length == 0) {            
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // required in the title of the taskListPage
          final completedTaskList = snapshot.data
            .where((Task task) => task.status == 1)
            .toList()
            .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80),
            physics: BouncingScrollPhysics(),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (context, index) {
              if(index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () async {
                          List<Map<String, dynamic>> queryRows = await DatabaseHelper.instance.getTaskMapList();
                          print(queryRows);                                                
                        },
                      ),
                      Text('My Tasks', 
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),),
                      SizedBox(height: 10,),
                      Text(
                        '$completedTaskList of ${snapshot.data.length}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),)
                    ],
                  ),
                );
              }

              return _buildTask(snapshot.data[index - 1]);
            },
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
      ),
    );
  }
}