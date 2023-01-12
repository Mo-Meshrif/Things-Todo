import 'package:dartz/dartz.dart';
import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../entities/task_to_do.dart';
import '../usecases/get_tasks_use_case.dart';
import '../usecases/send_problem_use_case.dart';

abstract class BaseHomeRespository {
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(TaskInputs parameter);
  Future<Either<LocalFailure, TaskTodo?>> getTaskById(int taskId);
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo);
  Future<Either<LocalFailure, int>> deleteTask(int taskId);
  Future<Either<ServerFailure, bool>> sendMessage(ChatMessage message);
  Future<Either<ServerFailure, void>> updateMessage(ChatMessage message);
  Future<Either<ServerFailure, Stream<List<ChatMessage>>>> getChatList(
    String uid,
  );
  Future<Either<ServerFailure, bool>> sendProblem(ProblemInput problemInput);
}
