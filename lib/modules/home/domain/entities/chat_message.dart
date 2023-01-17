import 'package:equatable/equatable.dart';
import '../../../../app/helper/enums.dart';
import '../../data/models/chat_message_model.dart';

class ChatMessage extends Equatable {
  final String? msgId;
  final String uid;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final MessageType type;
  final bool isMark;
  final bool isLoading;
  final bool isLocal;

  const ChatMessage({
    this.msgId,
    required this.uid,
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.isMark,
    this.isLoading = false,
    this.isLocal = false,
  });

  ChatMessage copyBaseWith({
    String? uid,
    String? idFrom,
    String? idTo,
    String? timestamp,
    String? content,
    MessageType? type,
    bool? isMark,
    bool? isLoading,
    bool? isLocal,
  }) =>
      ChatMessageModel(
        msgId: msgId,
        uid: uid ?? this.uid,
        idFrom: idFrom ?? this.idFrom,
        idTo: idTo ?? this.idTo,
        timestamp: timestamp ?? this.timestamp,
        content: content ?? this.content,
        type: type ?? this.type,
        isMark: isMark ?? this.isMark,
        isLoading: isLoading ?? this.isLoading,
        isLocal: isLocal ?? this.isLocal,
      );

  @override
  List<Object?> get props => [
        msgId,
        uid,
        idFrom,
        idTo,
        timestamp,
        content,
        type,
        isMark,
        isLoading,
        isLocal,
      ];
}
