import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_home_repository.dart';

class SendProblemUseCase
    implements BaseUseCase<Either<ServerFailure, bool>, ProblemInput> {
  final BaseHomeRespository baseHomeRespository;

  SendProblemUseCase(this.baseHomeRespository);

  @override
  Future<Either<ServerFailure, bool>> call(ProblemInput parameters) =>
      baseHomeRespository.sendProblem(parameters);
}

class ProblemInput {
  final String userId;
  final String problem;
  ProblemInput({required this.userId, required this.problem});
  toJson() => {
        'userId': userId,
        'problem': problem,
      };
}
