part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends HomeEvent {
  final TaskTodo taskTodo;
  const AddTaskEvent({required this.taskTodo});
}

class GetDailyTasksEvent extends HomeEvent {}

class GetWeeklyTasksEvent extends HomeEvent {}

class GetMonthlyTasksEvent extends HomeEvent {
  final DateTime date;
  final bool? sortedByMonth;

  const GetMonthlyTasksEvent({
    required this.date,
    this.sortedByMonth = true,
  });
}

class GetTaskByIdEvent extends HomeEvent {
  final int taskId;
  final bool withNav;
  final bool hideNotifyIcon;
  const GetTaskByIdEvent({
    required this.taskId,
    this.withNav = true,
    this.hideNotifyIcon = false,
  });
}

class EditTaskEvent extends HomeEvent {
  final TaskTodo taskTodo;
  const EditTaskEvent({required this.taskTodo});
}

class DeleteTaskEvent extends HomeEvent {
  final int taskId;
  const DeleteTaskEvent({required this.taskId});
}

class DeleteAllTasksEvent extends HomeEvent {}

class GetSearchedTasksEvent extends HomeEvent {
  final String searchedVal;

  const GetSearchedTasksEvent({required this.searchedVal});
}

class ClearSearchListEvent extends HomeEvent {}

class GetCustomTasksEvent extends HomeEvent {
  final String type;
  const GetCustomTasksEvent(this.type);
}

class SendMessageEvent extends HomeEvent {
  final ChatMessage chatMessage;
  const SendMessageEvent(this.chatMessage);
}

class UpdateMessageEvent extends HomeEvent {
  final ChatMessage chatMessage;
  const UpdateMessageEvent(this.chatMessage);
}

class SendProblemEvent extends HomeEvent {
  final ProblemInput problemInput;
  const SendProblemEvent(this.problemInput);
}
