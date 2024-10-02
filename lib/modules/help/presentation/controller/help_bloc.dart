import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_list_use_case.dart';
import '../../domain/usecases/send_message_use_case.dart';
import '../../domain/usecases/update_message_use_case.dart';

part 'help_event.dart';
part 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatListUseCae getChatListUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  HelpBloc({
    required this.sendMessageUseCase,
    required this.getChatListUseCase,
    required this.updateMessageUseCase,
  }) : super(HelpInitial()) {
    on<SendMessageEvent>(_sendMessage);
    on<UpdateMessageEvent>(_updateMessage);
  }
  FutureOr<void> _sendMessage(
      SendMessageEvent event, Emitter<HelpState> emit) async {
    emit(MessageLoading());
    final result = await sendMessageUseCase(event.chatMessage);
    result.fold(
      (failure) => emit(MessageFailure(msg: failure.msg)),
      (val) => emit(MessageLoaded(val: val)),
    );
  }

  Stream<List<ChatMessage>> getChatList(String chatGroupId) =>
      getChatListUseCase(chatGroupId);

  FutureOr<void> _updateMessage(
      UpdateMessageEvent event, Emitter<HelpState> emit) async {
    emit(MessageLoading());
    final result = await updateMessageUseCase(event.chatMessage);
    result.fold(
      (failure) => emit(MessageFailure(msg: failure.msg)),
      (_) => emit(const MessageLoaded(val: true)),
    );
  }
}
