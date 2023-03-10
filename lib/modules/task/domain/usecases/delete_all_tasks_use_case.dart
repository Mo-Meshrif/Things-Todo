import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_task_repository.dart';

class DeleteAllTasksUseCase
    implements BaseUseCase<Either<LocalFailure, bool>, NoParameters> {
  final BaseTaskRespository baseTaskRespository;

  DeleteAllTasksUseCase(this.baseTaskRespository);
  @override
  Future<Either<LocalFailure, bool>> call(_) async =>
      await baseTaskRespository.deleteAllTasks();
}
