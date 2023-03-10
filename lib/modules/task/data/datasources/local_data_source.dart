import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../models/task_model.dart';

abstract class BaseTaskLocalDataSource {
  Future<int> addTask(TaskModel taskModel);
  Future<List<TaskModel>> getTasks(TaskInputs parameter);
  Future<TaskModel?> getTaskById(int taskId);
  Future<TaskModel?> editTask(TaskModel taskModel);
  Future<int> deleteTask(int taskId);
  Future<bool> deleteAllTasks();
}

class TaskLocalDataSource implements BaseTaskLocalDataSource {
  TaskLocalDataSource._();
  static final TaskLocalDataSource db = TaskLocalDataSource._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'Tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,uid TEXT NOT NULL,name TEXT NOT NULL, description TEXT NOT NULL, category TEXT NOT NULL,date TEXT NOT NULL, day INTEGER NOT NULL,firstDayOfWeek INTEGER NOT NULL,endDayOfWeek INTEGER NOT NULL,month INTEGER NOT NULL,year INTEGER NOT NULL,priority INTEGER NOT NULL,important INTEGER NOT NULL,done INTEGER NOT NULL,later INTEGER NOT NULL,speicalKey INTEGER NOT NULL)');
      },
    );
  }

  @override
  Future<int> addTask(TaskModel taskModel) async {
    try {
      var dbClient = await database;
      int id = await dbClient!.insert(
        'tasks',
        taskModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<List<TaskModel>> getTasks(TaskInputs parameter) async {
    try {
      String uid = HelperFunctions.getSavedUser().id;
      var dbClient = await database;
      List<Map<String, Object?>> maps = await dbClient!.query(
        'tasks',
        orderBy: 'date DESC',
        where: 'uid=? AND ' + parameter.where,
        whereArgs: [
          ...[uid],
          ...parameter.whereArgs
        ],
      );
      return maps.isNotEmpty
          ? maps.map((e) => TaskModel.fromJson(e)).toList()
          : [];
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<TaskModel?> getTaskById(int taskId) async {
    try {
      var dbClient = await database;
      List<Map<String, Object?>> maps = await dbClient!.query(
        'tasks',
        where: 'id=?',
        whereArgs: [taskId],
      );
      return maps.isNotEmpty ? TaskModel.fromJson(maps[0]) : null;
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<TaskModel?> editTask(TaskModel taskModel) async {
    try {
      var dbClient = await database;
      int id = await dbClient!.update(
        'tasks',
        taskModel.toJson(),
        where: 'id=?',
        whereArgs: [taskModel.id],
      );
      return id != 0 ? taskModel : null;
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<int> deleteTask(int taskId) async {
    try {
      var dbClient = await database;
      int val = await dbClient!.delete(
        'tasks',
        where: 'id=?',
        whereArgs: [taskId],
      );
      return val == 1 ? taskId : -1;
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<bool> deleteAllTasks() async {
    try {
      var dbClient = await database;
      int val = await dbClient!.delete(
        'tasks',
        where: 'uid=?',
        whereArgs: [HelperFunctions.getSavedUser().id],
      );
      return val == 1;
    } on DatabaseException catch (e) {
      throw LocalExecption(e.toString());
    }
  }
}
