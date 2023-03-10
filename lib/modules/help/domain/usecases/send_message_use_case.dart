import 'package:dartz/dartz.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../repositories/base_help_repository.dart';

class SendMessageUseCase
    implements BaseUseCase<Either<ServerFailure, bool>, ChatMessage> {
  final BaseHelpRespository baseHelpRespository;

  SendMessageUseCase(this.baseHelpRespository);

  @override
  Future<Either<ServerFailure, bool>> call(ChatMessage parameters) =>
      baseHelpRespository.sendMessage(parameters);
}
