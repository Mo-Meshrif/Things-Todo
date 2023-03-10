import 'package:dartz/dartz.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/services/network_services.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/base_help_repository.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../datasources/remote_data_source.dart';
import '../models/chat_message_model.dart';

class HelpRepositoryImpl implements BaseHelpRespository {
  final BaseHelpRemoteDataSource baseHelpRemoteDataSource;
  final NetworkServices networkServices;

  HelpRepositoryImpl(
    this.baseHelpRemoteDataSource,
    this.networkServices,
  );
  @override
  Future<Either<ServerFailure, bool>> sendMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseHelpRemoteDataSource.sendMessage(ChatMessageModel(
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
      baseHelpRemoteDataSource.getChatList(chatGroupId);

  @override
  Future<Either<ServerFailure, void>> updateMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        var val = await baseHelpRemoteDataSource.updateMessage(
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
        final val = await baseHelpRemoteDataSource.sendProblem(problemInput);
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }
}
