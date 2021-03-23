import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  Widget _buildTask(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text('Task Title'),
            subtitle: Text('Mar 23, 2021 • High'),
            trailing: Checkbox(
              onChanged: (value) {
                print(value);
              },
              value: true,
              activeColor: Theme.of(context).primaryColor,
            ),
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

      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 80),
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          if(index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Tasks', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 10,),
                  Text('1 of 10',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),)
                ],
              ),
            );
          }

          return _buildTask(index);
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
      ),
    );
  }
}