part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeTranstion extends HomeState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class AddTaskLoaded extends HomeState {
  final bool isAdded;
  const AddTaskLoaded({required this.isAdded});

  @override
  List<Object?> get props => [isAdded];
}

class DailyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class DailyTaskLoaded extends HomeState {
  final List<TaskTodo> dailyList;

  const DailyTaskLoaded({required this.dailyList});

  @override
  List<Object?> get props => [dailyList];
}

class WeeklyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class WeeklyTaskLoaded extends HomeState {
  final List<TaskTodo> weeklyList;
  const WeeklyTaskLoaded({required this.weeklyList});

  @override
  List<Object?> get props => [weeklyList];
}

class MonthlyTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class MonthlyTaskLoaded extends HomeState {
  final List<TaskTodo> monthlyList;
  const MonthlyTaskLoaded({required this.monthlyList});

  @override
  List<Object?> get props => [monthlyList];
}

class GetTaskByIdLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class GetTaskByIdLoaded extends HomeState {
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

class EditTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class EditTaskLoaded extends HomeState {
  final TaskTodo? task;
  const EditTaskLoaded({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class DeleteTaskLLoaded extends HomeState {
  final int taskId;
  const DeleteTaskLLoaded({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class SearchedTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class SearchedTaskLoaded extends HomeState {
  final List<TaskTodo> searchedList;
  const SearchedTaskLoaded({required this.searchedList});

  @override
  List<Object?> get props => [searchedList];
}

class HomeFailure extends HomeState {
  final String msg;
  const HomeFailure({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class CustomTaskLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class CustomTaskLoaded extends HomeState {
  final List<TaskTodo> customList;
  const CustomTaskLoaded({required this.customList});

  @override
  List<Object?> get props => [customList];
}

class MessageLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class MessageLoaded extends HomeState {
  final bool val;

  const MessageLoaded({required this.val});
  @override
  List<Object> get props => [val];
}

class MessageFailure extends HomeState {
  final String msg;

  const MessageFailure({required this.msg});
  @override
  List<Object> get props => [msg];
}

class ProblemLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class ProblemLoaded extends HomeState {
  final bool val;

  const ProblemLoaded({required this.val});
  @override
  List<Object> get props => [val];
}

class ProblemFailure extends HomeState {
  final String msg;

  const ProblemFailure({required this.msg});
  @override
  List<Object> get props => [msg];
}
