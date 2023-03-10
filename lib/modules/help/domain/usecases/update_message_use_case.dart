import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../repositories/base_help_repository.dart';

class UpdateMessageUseCase
    implements BaseUseCase<Either<ServerFailure, void>, ChatMessage> {
  final BaseHelpRespository baseHelpRespository;

  UpdateMessageUseCase(this.baseHelpRespository);

  @override
  Future<Either<ServerFailure, void>> call(ChatMessage parameters) =>
      baseHelpRespository.updateMessage(parameters);
}
