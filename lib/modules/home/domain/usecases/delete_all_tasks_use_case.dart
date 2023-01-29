import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_home_repository.dart';

class DeleteAllTasksUseCase
    implements BaseUseCase<Either<LocalFailure, bool>, NoParameters> {
  final BaseHomeRespository baseHomeRespository;

  DeleteAllTasksUseCase(this.baseHomeRespository);
  @override
  Future<Either<LocalFailure, bool>> call(_) async =>
      await baseHomeRespository.deleteAllTasks();
}
