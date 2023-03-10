import 'package:equatable/equatable.dart';

import '../../../../app/helper/enums.dart';
import '../../data/models/chat_message_model.dart';

class ChatMessage extends Equatable {
  final String? msgId;
  final String? groupId;
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
    this.groupId,
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
    String? groupId,
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
        groupId: groupId ?? this.groupId,
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
        groupId,
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
