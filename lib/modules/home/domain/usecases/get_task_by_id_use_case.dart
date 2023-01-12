import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../repositories/base_home_repository.dart';

class GetTaskByIdUseCae
    implements BaseUseCase<Either<LocalFailure, TaskTodo?>, int> {
  final BaseHomeRespository baseHomeRespository;
  GetTaskByIdUseCae(this.baseHomeRespository);
  
  @override
  Future<Either<LocalFailure, TaskTodo?>> call(int parameters) =>
      baseHomeRespository.getTaskById(parameters);
}
