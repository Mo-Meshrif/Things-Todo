import 'package:dartz/dartz.dart';
import '../../../../app/services/notification_services.dart';
import '/app/helper/extentions.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/services/network_services.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/repositories/base_home_repository.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/chat_message_model.dart';
import '../models/task_model.dart';

class HomeRepositoryImpl implements BaseHomeRespository {
  final BaseHomeRemoteDataSource baseHomeRemoteDataSource;
  final BaseHomeLocalDataSource baseHomeLocalDataSource;
  final NotificationServices notificationServices;
  final NetworkServices networkServices;

  HomeRepositoryImpl(
    this.baseHomeLocalDataSource,
    this.baseHomeRemoteDataSource,
    this.notificationServices,
    this.networkServices,
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
      );
      final id = await baseHomeLocalDataSource.addTask(taskModel);
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
      final tasks = await baseHomeLocalDataSource.getTasks(parameter);
      return Right(tasks);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, TaskTodo?>> getTaskById(int taskId) async {
    try {
      final task = await baseHomeLocalDataSource.getTaskById(taskId);
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
      );
      final task = await baseHomeLocalDataSource.editTask(taskModel);
      _createTaskReminder(
        task == null
            ? taskTodo.copyWith(id: 0)
            : TaskTodo(
                id: task.id,
                name: task.name,
                category: task.category,
                date: task.date,
                description: task.description,
                priority: task.priority,
                important: task.important,
              ),
      );
      return Right(task);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, int>> deleteTask(int taskId) async {
    try {
      final id = await baseHomeLocalDataSource.deleteTask(taskId);
      _cancelScheduledNotifications(id);
      return Right(id);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<ServerFailure, bool>> sendMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseHomeRemoteDataSource.sendMessage(ChatMessageModel(
            groupId: message.groupId,
            idFrom: message.idFrom,
            idTo: message.idTo,
            timestamp: message.timestamp,
            content: message.content,
            type: message.type,
            isMark: message.isMark));
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  @override
  Stream<List<ChatMessage>> getChatList(String chatGroupId) =>
      baseHomeRemoteDataSource.getChatList(chatGroupId);

  @override
  Future<Either<ServerFailure, void>> updateMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        var val = await baseHomeRemoteDataSource.updateMessage(
          ChatMessageModel(
            msgId: message.msgId,
            groupId: message.groupId,
            idFrom: message.idFrom,
            idTo: message.idTo,
            timestamp: message.timestamp,
            content: message.content,
            type: message.type,
            isMark: message.isMark,
          ),
        );
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  @override
  Future<Either<ServerFailure, bool>> sendProblem(
      ProblemInput problemInput) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseHomeRemoteDataSource.sendProblem(problemInput);
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  _createTaskReminder(TaskTodo taskTodo, {bool isEdit = false}) async {
    if (taskTodo.id != 0) {
      if (isEdit) {
        _cancelScheduledNotifications(taskTodo.id!);
      }
      await notificationServices.createTaskReminderNotification(
        taskTodo,
      );
    }
  }

  _cancelScheduledNotifications(int id) async {
    await notificationServices.cancelScheduledNotifications(id);
  }
}
