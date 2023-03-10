part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final TaskTodo taskTodo;
  const AddTaskEvent({required this.taskTodo});
}

class GetDailyTasksEvent extends TaskEvent {}

class GetWeeklyTasksEvent extends TaskEvent {}

class GetMonthlyTasksEvent extends TaskEvent {
  final DateTime date;
  final bool? sortedByMonth;

  const GetMonthlyTasksEvent({
    required this.date,
    this.sortedByMonth = true,
  });
}

class GetTaskByIdEvent extends TaskEvent {
  final int taskId;
  final bool withNav;
  final bool hideNotifyIcon;
  const GetTaskByIdEvent({
    required this.taskId,
    this.withNav = true,
    this.hideNotifyIcon = false,
  });
}

class EditTaskEvent extends TaskEvent {
  final TaskTodo taskTodo;
  const EditTaskEvent({required this.taskTodo});
}

class DeleteTaskEvent extends TaskEvent {
  final DeleteTaskParameters deleteTaskParameters ;
  const DeleteTaskEvent({required this.deleteTaskParameters});
}

class DeleteAllTasksEvent extends TaskEvent {}

class GetSearchedTasksEvent extends TaskEvent {
  final String searchedVal;

  const GetSearchedTasksEvent({required this.searchedVal});
}

class ClearSearchListEvent extends TaskEvent {}

class GetCustomTasksEvent extends TaskEvent {
  final String type;
  const GetCustomTasksEvent(this.type);
}
