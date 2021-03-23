import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';

class DatabaseHelper {

  // creating a singleton instance to use in all the codes
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String tasksTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDateTime = 'dateTime';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    if(_db == null) {
      _db = await _initDatabase();
    }
    return _db;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  // Creating the database if there is none created
  void _createDb(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $tasksTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT,
      $colDateTime TEXT,
      $colPriority TEXT,
      $colStatus TEXT)
      '''
    );
  }


  // -----------------Getting all the queries-----------------
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.map((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }
  


  // ----------Inserting Tasks in the DB----------
  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }  


  // ----------Updating Tasks in the DB----------
  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable, 
      task.toMap(), 
      where: '$colId = ?', 
      whereArgs: [task.id]
    );
    return result;
  }


  // ----------Deleting Tasks in the DB----------
  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tasksTable,
      where: '$colId = ?',
      whereArgs: [id]
    );
    return result;
  }

}