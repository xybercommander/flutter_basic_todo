import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helper/database_helper.dart';
import 'package:todo_app/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  // DATE PICKER FUNCTION
  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );

    if(date != null && date != date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date).toString();
    }
  }

  // SUBMIT FUNCTION
  _submit() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_date, $_priority');
      
      Task task = Task(title: _title, date: _date, priority: _priority);
      if(widget.task == null) {
        // -----------Insert the task to the database-----------
        task.status = 0;
        int i = await DatabaseHelper.instance.insertTask(task);
        print('Inserted id : $i');
      } else {
        // -----------Updating the task in the database-----------
        task.status = widget.task.status; 
        int i = await DatabaseHelper.instance.updateTask(task);
        print('Updated id : $i');
      }      

      Navigator.pop(context);
    }
  }


  @override
  void initState() {    
    super.initState();

    // This will get called only if we are updating an exisiting task
    if(widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _priority = widget.task.priority;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {    
    super.dispose();
    _dateController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(                    
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 30, color: Theme.of(context).primaryColor,),
              ),
              SizedBox(height: 20,),
              Text('Add Task',
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    // Title Form Field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        validator: (input) => input.trim().isEmpty ? 'Please Enter a value' : null,
                        onSaved: (input) => _title = input,
                        initialValue: _title,
                      ),
                    ),

                    // Date Form Field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        readOnly: true, // This disables the user to type anything in the date
                        controller: _dateController,
                        style: TextStyle(fontSize: 18),
                        onTap: _handleDatePicker,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
                    ),

                    // Priority Form Field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        style: TextStyle(fontSize: 18),
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        validator: (input) => _priority == null ? 'Please select a priority level' : null,                    
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                          });
                        },                   
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: FlatButton(
                        shape: StadiumBorder(),
                        splashColor: Colors.white54,                      
                        child: Text('Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),),
                        onPressed: _submit,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}