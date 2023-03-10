import 'package:dartz/dartz.dart';

import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../usecases/send_problem_use_case.dart';

abstract class BaseHelpRespository {
  Future<Either<ServerFailure, bool>> sendMessage(ChatMessage message);
  Future<Either<ServerFailure, void>> updateMessage(ChatMessage message);
  Stream<List<ChatMessage>> getChatList(String chatGroupId);
  Future<Either<ServerFailure, bool>> sendProblem(ProblemInput problemInput);
}
