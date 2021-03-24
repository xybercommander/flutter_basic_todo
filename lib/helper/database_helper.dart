import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // creating a singleton instance to use in all the codes
  DatabaseHelper._privateConstuctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstuctor();
  static Database _db;    
  String _dbName = 'todo_list.db';

  String tasksTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await _initDatabase();
      return _db;
    }    
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path + _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Creating the database if there is none created
  void _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $tasksTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT,
      $colDate TEXT,
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
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
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