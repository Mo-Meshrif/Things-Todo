import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/task_to_do.dart';
import '../repositories/base_task_repository.dart';

class GetTasksUseCase
    implements BaseUseCase<Either<LocalFailure, List<TaskTodo>>, TaskInputs> {
  final BaseTaskRespository baseTaskRespository;
  GetTasksUseCase(this.baseTaskRespository);

  @override
  Future<Either<LocalFailure, List<TaskTodo>>> call(TaskInputs parameter) =>
      baseTaskRespository.getTasks(parameter);
}

class TaskInputs extends Equatable {
  final List<Object> whereArgs;
  final String where;

  const TaskInputs({required this.whereArgs, required this.where});

  @override
  List<Object?> get props => [whereArgs, where];
}
