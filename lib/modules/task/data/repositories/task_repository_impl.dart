import 'package:dartz/dartz.dart';
import '../../../../app/services/notification_services.dart';
import '../../domain/repositories/base_task_repository.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '/app/helper/extentions.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/helper_functions.dart';

import '../../domain/entities/task_to_do.dart';
import '../datasources/local_data_source.dart';

import '../models/task_model.dart';

class TaskRepositoryImpl implements BaseTaskRespository {
  final BaseTaskLocalDataSource baseTaskLocalDataSource;
  final NotificationServices notificationServices;

  TaskRepositoryImpl(
    this.baseTaskLocalDataSource,
    this.notificationServices,
  );
  @override
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      int firstDayOfWeek = date.firstDayOfWeek();
      TaskModel taskModel = TaskModel(
        uid: HelperFunctions.getSavedUser().id,
        name: taskTodo.name,
        description: taskTodo.description,
        category: taskTodo.category,
        date: taskTodo.date,
        day: date.day,
        firstDayOfWeek: firstDayOfWeek,
        endDayOfWeek: firstDayOfWeek + 6,
        month: date.month,
        year: date.year,
        priority: taskTodo.priority,
        important: taskTodo.important,
        done: taskTodo.done,
        later: taskTodo.later,
        speicalKey: taskTodo.speicalKey,
      );
      final id = await baseTaskLocalDataSource.addTask(taskModel);
      _createTaskReminder(taskTodo.copyWith(id: id));
      return Right(id == 0 ? false : true);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(
      TaskInputs parameter) async {
    try {
      final tasks = await baseTaskLocalDataSource.getTasks(parameter);
      return Right(tasks);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, TaskTodo?>> getTaskById(int taskId) async {
    try {
      final task = await baseTaskLocalDataSource.getTaskById(taskId);
      return Right(task);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      int firstDayOfWeek = date.firstDayOfWeek();
      TaskModel taskModel = TaskModel(
        id: taskTodo.id,
        uid: HelperFunctions.getSavedUser().id,
        name: taskTodo.name,
        description: taskTodo.description,
        category: taskTodo.category,
        date: taskTodo.date,
        day: date.day,
        firstDayOfWeek: firstDayOfWeek,
        endDayOfWeek: firstDayOfWeek + 6,
        month: date.month,
        year: date.year,
        priority: taskTodo.priority,
        important: taskTodo.important,
        done: taskTodo.done,
        later: taskTodo.later,
        speicalKey: taskTodo.speicalKey,
      );
      final task = await baseTaskLocalDataSource.editTask(taskModel);
      if (task != null) {
        _createTaskReminder(taskTodo);
      }
      return Right(task);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, int>> deleteTask(
      DeleteTaskParameters parameters) async {
    try {
      final id = await baseTaskLocalDataSource.deleteTask(parameters.taskId);
      _cancelScheduledNotificationById(parameters.speicalKey);
      return Right(id);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, bool>> deleteAllTasks() async {
    try {
      final val = await baseTaskLocalDataSource.deleteAllTasks();
      notificationServices.cancelAllScheduledNotifications();
      return Right(val);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  _createTaskReminder(TaskTodo taskTodo) async {
    if (taskTodo.id != 0) {
      await notificationServices.createTaskReminderNotification(
        taskTodo,
      );
    }
  }

  _cancelScheduledNotificationById(int id) async {
    await notificationServices.cancelScheduledNotificationById(id);
  }
}
