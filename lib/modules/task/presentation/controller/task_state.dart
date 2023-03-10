part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskTranstion extends TaskState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoaded extends TaskState {
  final bool isAdded;
  const AddTaskLoaded({required this.isAdded});

  @override
  List<Object?> get props => [isAdded];
}

class DailyTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class DailyTaskLoaded extends TaskState {
  final List<TaskTodo> dailyList;

  const DailyTaskLoaded({required this.dailyList});

  @override
  List<Object?> get props => [dailyList];
}

class WeeklyTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class WeeklyTaskLoaded extends TaskState {
  final List<TaskTodo> weeklyList;
  const WeeklyTaskLoaded({required this.weeklyList});

  @override
  List<Object?> get props => [weeklyList];
}

class MonthlyTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class MonthlyTaskLoaded extends TaskState {
  final List<TaskTodo> monthlyList;
  const MonthlyTaskLoaded({required this.monthlyList});

  @override
  List<Object?> get props => [monthlyList];
}

class GetTaskByIdLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class GetTaskByIdLoaded extends TaskState {
  final TaskTodo? task;
  final bool withNav;
  final bool hideNotifyIcon;
  const GetTaskByIdLoaded({
    required this.task,
    this.withNav = true,
    this.hideNotifyIcon = false,
  });

  @override
  List<Object?> get props => [task];
}

class EditTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class EditTaskLoaded extends TaskState {
  final TaskTodo? task;
  const EditTaskLoaded({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class DeleteTaskLLoaded extends TaskState {
  final int taskId;
  const DeleteTaskLLoaded({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeleteAllTasksLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class DeleteAllTasksLoaded extends TaskState {
  final bool isDeletedAll;

  const DeleteAllTasksLoaded({required this.isDeletedAll});
  @override
  List<Object?> get props => [];
}

class SearchedTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class SearchedTaskLoaded extends TaskState {
  final List<TaskTodo> searchedList;
  const SearchedTaskLoaded({required this.searchedList});

  @override
  List<Object?> get props => [searchedList];
}

class TaskFailure extends TaskState {
  final String msg;
  const TaskFailure({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class CustomTaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class CustomTaskLoaded extends TaskState {
  final List<TaskTodo> customList;
  const CustomTaskLoaded({required this.customList});

  @override
  List<Object?> get props => [customList];
}
