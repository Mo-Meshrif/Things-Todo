import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/extentions.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/usecases/add_task_use_case.dart';
import '../../domain/usecases/delete_all_tasks_use_case.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/edit_task_use_case.dart';
import '../../domain/usecases/get_task_by_id_use_case.dart';
import '../../domain/usecases/get_tasks_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTaskUseCase addTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final GetTaskByIdUseCae getTaskByIdUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final DeleteAllTasksUseCase deleteAllTasksUseCase;
  TaskBloc({
    required this.addTaskUseCase,
    required this.getTasksUseCase,
    required this.getTaskByIdUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
    required this.deleteAllTasksUseCase,
  }) : super(TaskInitial()) {
    on<AddTaskEvent>(_addTask);
    on<GetDailyTasksEvent>(_getDailyTasks);
    on<GetWeeklyTasksEvent>(_getWeeklyTasks);
    on<GetMonthlyTasksEvent>(_getMonthlyTasks);
    on<GetTaskByIdEvent>(_getTaskById);
    on<EditTaskEvent>(_editTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<DeleteAllTasksEvent>(_deleteAllTasks);
    on<GetSearchedTasksEvent>(_getSearchedTasks);
    on<GetCustomTasksEvent>(_getCustomTasks);
    on<ClearSearchListEvent>((_, emit) => emit(TaskTranstion()));
  }
  FutureOr<void> _addTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(AddTaskLoading());
    final result = await addTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (isAdded) => emit(AddTaskLoaded(isAdded: isAdded)),
    );
  }

  FutureOr<void> _getDailyTasks(
      GetDailyTasksEvent event, Emitter<TaskState> emit) async {
    emit(DailyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [date.day, date.firstDayOfWeek(), date.month, date.year],
        where: 'day=? AND firstDayOfWeek=? AND month=? AND year=?',
      ),
    );

    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (tasks) => emit(DailyTaskLoaded(dailyList: tasks)),
    );
  }

  FutureOr<void> _getWeeklyTasks(
      GetWeeklyTasksEvent event, Emitter<TaskState> emit) async {
    emit(WeeklyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(_weekInputs(date));
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (tasks) => emit(WeeklyTaskLoaded(weeklyList: tasks)),
    );
  }

  FutureOr<void> _getMonthlyTasks(
      GetMonthlyTasksEvent event, Emitter<TaskState> emit) async {
    emit(MonthlyTaskLoading());
    DateTime date = event.date;
    //The method of work is determined based on the customer's choice (week or month)
    final result = await _getTasks(
      event.sortedByMonth == true
          ? TaskInputs(
              whereArgs: [date.month, date.year],
              where: 'month=? AND year=?',
            )
          : _weekInputs(date),
    );
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (tasks) => emit(MonthlyTaskLoaded(monthlyList: tasks)),
    );
  }

  Future<Either<LocalFailure, List<TaskTodo>>> _getTasks(
          TaskInputs taskInputs) =>
      getTasksUseCase(taskInputs);

  FutureOr<void> _getTaskById(
      GetTaskByIdEvent event, Emitter<TaskState> emit) async {
    emit(GetTaskByIdLoading());
    final result = await getTaskByIdUseCase(event.taskId);
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (task) => emit(GetTaskByIdLoaded(
        task: task,
        withNav: event.withNav,
        hideNotifyIcon: event.hideNotifyIcon,
      )),
    );
  }

  FutureOr<void> _editTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(EditTaskLoading());
    final result = await editTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (task) => emit(EditTaskLoaded(task: task)),
    );
  }

  FutureOr<void> _deleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(DeleteTaskLoading());
    final result = await deleteTaskUseCase(event.deleteTaskParameters);
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (taskId) => emit(DeleteTaskLLoaded(taskId: taskId)),
    );
  }

  FutureOr<void> _deleteAllTasks(
      DeleteAllTasksEvent event, Emitter<TaskState> emit) async {
    emit(DeleteAllTasksLoading());
    final result = await deleteAllTasksUseCase(const NoParameters());
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (val) => emit(DeleteAllTasksLoaded(isDeletedAll: val)),
    );
  }

  FutureOr<void> _getSearchedTasks(
      GetSearchedTasksEvent event, Emitter<TaskState> emit) async {
    emit(SearchedTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [event.searchedVal + '%'],
        where: 'name LIKE ?',
      ),
    );
    await Future.delayed(const Duration(seconds: 1), () {}).whenComplete(() {
      result.fold(
        (failure) => emit(TaskFailure(msg: failure.msg)),
        (tasks) => emit(SearchedTaskLoaded(searchedList: tasks)),
      );
    });
  }

  FutureOr<void> _getCustomTasks(
      GetCustomTasksEvent event, Emitter<TaskState> emit) async {
    emit(CustomTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: const [1],
        where: event.type + '=?',
      ),
    );
    result.fold(
      (failure) => emit(TaskFailure(msg: failure.msg)),
      (tasks) => emit(CustomTaskLoaded(customList: tasks)),
    );
  }

  TaskInputs _weekInputs(DateTime date) {
    int firstDayOfWeek = date.firstDayOfWeek();
    return TaskInputs(
      whereArgs: [firstDayOfWeek, firstDayOfWeek + 6, date.year],
      where: 'firstDayOfWeek=? AND endDayOfWeek=? AND year=?',
    );
  }
}
