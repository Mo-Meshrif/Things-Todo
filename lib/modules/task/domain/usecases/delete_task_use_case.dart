import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../repositories/base_task_repository.dart';

class DeleteTaskUseCase implements BaseUseCase<Either<LocalFailure, int>, DeleteTaskParameters> {
  final BaseTaskRespository baseTaskRespository;

  DeleteTaskUseCase(this.baseTaskRespository);
  @override
  Future<Either<LocalFailure, int>> call(DeleteTaskParameters parameters) async =>
      await baseTaskRespository.deleteTask(parameters);
}

class DeleteTaskParameters extends Equatable {
  final int taskId, speicalKey;

  const DeleteTaskParameters({
    required this.taskId,
    required this.speicalKey,
  });

  @override
  List<Object?> get props => [
        taskId,
        speicalKey,
      ];
}
