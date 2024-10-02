part of 'help_bloc.dart';

abstract class HelpEvent extends Equatable {
  const HelpEvent();

  @override
  List<Object> get props => [];
}
class SendMessageEvent extends HelpEvent {
  final ChatMessage chatMessage;
  const SendMessageEvent(this.chatMessage);
}

class UpdateMessageEvent extends HelpEvent {
  final ChatMessage chatMessage;
  const UpdateMessageEvent(this.chatMessage);
}