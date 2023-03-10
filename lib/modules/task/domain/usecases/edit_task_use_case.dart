import 'package:dartz/dartz.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../repositories/base_task_repository.dart';

class EditTaskUseCase
    implements BaseUseCase<Either<LocalFailure, TaskTodo?>, TaskTodo> {
  final BaseTaskRespository baseTaskRespository;

  EditTaskUseCase(this.baseTaskRespository);
  @override
  Future<Either<LocalFailure, TaskTodo?>> call(TaskTodo taskTodo) =>
      baseTaskRespository.editTask(taskTodo);
}
