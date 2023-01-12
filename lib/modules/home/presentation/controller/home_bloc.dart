import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_task_by_id_use_case.dart';
import '/app/helper/extentions.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/usecases/add_task_use_case.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/edit_task_use_case.dart';
import '../../domain/usecases/get_chat_list_use_case.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../domain/usecases/send_message_use_case.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../../domain/usecases/update_message_use_case.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddTaskUseCase addTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final GetTaskByIdUseCae getTaskByIdUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetChatListUseCae getChatListUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final SendProblemUseCase sendProblemUseCase;
  HomeBloc({
    required this.addTaskUseCase,
    required this.getTasksUseCase,
    required this.getTaskByIdUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
    required this.sendMessageUseCase,
    required this.getChatListUseCase,
    required this.updateMessageUseCase,
    required this.sendProblemUseCase,
  }) : super(HomeInitial()) {
    on<AddTaskEvent>(_addTask);
    on<GetDailyTasksEvent>(_getDailyTasks);
    on<GetWeeklyTasksEvent>(_getWeeklyTasks);
    on<GetMonthlyTasksEvent>(_getMonthlyTasks);
    on<GetTaskByIdEvent>(_getTaskById);
    on<EditTaskEvent>(_editTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<GetSearchedTasksEvent>(_getSearchedTasks);
    on<GetCustomTasksEvent>(_getCustomTasks);
    on<ClearSearchListEvent>((_, emit) => emit(HomeTranstion()));
    on<SendMessageEvent>(_sendMessage);
    on<UpdateMessageEvent>(_updateMessage);
    on<GetChatListEvent>(_getChatList);
    on<LoadChatListEvent>(
        (event, emit) => emit(ChatLoaded(messages: event.messages)));
    on<SendProblemEvent>(_sendProblem);
  }

  FutureOr<void> _addTask(AddTaskEvent event, Emitter<HomeState> emit) async {
    emit(AddTaskLoading());
    final result = await addTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (isAdded) => emit(AddTaskLoaded(isAdded: isAdded)),
    );
  }

  FutureOr<void> _getDailyTasks(
      GetDailyTasksEvent event, Emitter<HomeState> emit) async {
    emit(DailyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [date.day, date.firstDayOfWeek(), date.month, date.year],
        where: 'day=? AND firstDayOfWeek=? AND month=? AND year=?',
      ),
    );

    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(DailyTaskLoaded(dailyList: tasks)),
    );
  }

  FutureOr<void> _getWeeklyTasks(
      GetWeeklyTasksEvent event, Emitter<HomeState> emit) async {
    emit(WeeklyTaskLoading());
    DateTime date = DateTime.now();
    final result = await _getTasks(_weekInputs(date));
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(WeeklyTaskLoaded(weeklyList: tasks)),
    );
  }

  FutureOr<void> _getMonthlyTasks(
      GetMonthlyTasksEvent event, Emitter<HomeState> emit) async {
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
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(MonthlyTaskLoaded(monthlyList: tasks)),
    );
  }

  Future<Either<LocalFailure, List<TaskTodo>>> _getTasks(
          TaskInputs taskInputs) =>
      getTasksUseCase(taskInputs);

  FutureOr<void> _getTaskById(
      GetTaskByIdEvent event, Emitter<HomeState> emit) async {
    emit(GetTaskByIdLoading());
    final result = await getTaskByIdUseCase(event.taskId);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (task) => emit(GetTaskByIdLoaded(
        task: task,
        withNav: event.withNav,
        hideNotifyIcon: event.hideNotifyIcon,
      )),
    );
  }

  FutureOr<void> _editTask(EditTaskEvent event, Emitter<HomeState> emit) async {
    emit(EditTaskLoading());
    final result = await editTaskUseCase(event.taskTodo);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (task) => emit(EditTaskLoaded(task: task)),
    );
  }

  FutureOr<void> _deleteTask(
      DeleteTaskEvent event, Emitter<HomeState> emit) async {
    emit(DeleteTaskLoading());
    final result = await deleteTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (taskId) => emit(DeleteTaskLLoaded(taskId: taskId)),
    );
  }

  FutureOr<void> _getSearchedTasks(
      GetSearchedTasksEvent event, Emitter<HomeState> emit) async {
    emit(SearchedTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: [event.searchedVal + '%'],
        where: 'name LIKE ?',
      ),
    );
    await Future.delayed(const Duration(seconds: 1), () {}).whenComplete(() {
      result.fold(
        (failure) => emit(HomeFailure(msg: failure.msg)),
        (tasks) => emit(SearchedTaskLoaded(searchedList: tasks)),
      );
    });
  }

  FutureOr<void> _getCustomTasks(
      GetCustomTasksEvent event, Emitter<HomeState> emit) async {
    emit(CustomTaskLoading());
    final result = await _getTasks(
      TaskInputs(
        whereArgs: const [1],
        where: event.type + '=?',
      ),
    );
    result.fold(
      (failure) => emit(HomeFailure(msg: failure.msg)),
      (tasks) => emit(CustomTaskLoaded(customList: tasks)),
    );
  }

  FutureOr<void> _sendMessage(
      SendMessageEvent event, Emitter<HomeState> emit) async {
    emit(MessageLoading());
    final result = await sendMessageUseCase(event.chatMessage);
    result.fold(
      (failure) => emit(MessageFailure(msg: failure.msg)),
      (val) => emit(MessageLoaded(val: val)),
    );
  }

  FutureOr<void> _getChatList(
      GetChatListEvent event, Emitter<HomeState> emit) async {
    emit(ChatLoading());
    final result = await getChatListUseCase(HelperFunctions.getSavedUser().id);
    result.fold(
      (failure) => emit(ChatFailure(msg: failure.msg)),
      (streamResponse) => streamResponse.listen(
        (messages) => add(LoadChatListEvent(messages)),
      ),
    );
  }

  FutureOr<void> _updateMessage(
      UpdateMessageEvent event, Emitter<HomeState> emit) async {
    emit(MessageLoading());
    final result = await updateMessageUseCase(event.chatMessage);
    result.fold(
      (failure) => emit(MessageFailure(msg: failure.msg)),
      (_) => emit(const MessageLoaded(val: true)),
    );
  }

  FutureOr<void> _sendProblem(
      SendProblemEvent event, Emitter<HomeState> emit) async {
    emit(ProblemLoading());
    final result = await sendProblemUseCase(event.problemInput);
    result.fold(
      (failure) => emit(ProblemFailure(msg: failure.msg)),
      (val) => emit(ProblemLoaded(val: val)),
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
