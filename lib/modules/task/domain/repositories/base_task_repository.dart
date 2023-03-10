import 'package:dartz/dartz.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../usecases/delete_task_use_case.dart';
import '../usecases/get_tasks_use_case.dart';

abstract class BaseTaskRespository {
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(TaskInputs parameter);
  Future<Either<LocalFailure, TaskTodo?>> getTaskById(int taskId);
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, int>> deleteTask(DeleteTaskParameters parameters);
  Future<Either<LocalFailure, bool>> deleteAllTasks();
}
