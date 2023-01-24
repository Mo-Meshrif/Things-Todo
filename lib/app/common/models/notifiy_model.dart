import '../../../app/helper/extentions.dart';
import '../../helper/enums.dart';

class NotifyActionModel {
  final String toToken, toId, fromId, title;
  final MessageType type;
  final String? body;

  NotifyActionModel({
    required this.toToken,
    required this.toId,
    required this.fromId,
    required this.title,
    this.body,
    required this.type,
  });
}

class ReceivedNotifyModel {
  final int id;
  final String? title;
  final String? body;
  final MessageType? type;
  final DateTime? date;
  final String? buttonKeyPressed;
  final bool isOpened;
  final String? from, to;

  ReceivedNotifyModel({
    this.from,
    this.to,
    required this.id,
    this.title,
    this.body,
    this.type,
    this.date,
    this.buttonKeyPressed,
    this.isOpened = false,
  });

  factory ReceivedNotifyModel.fromJson(Map<String, dynamic> map) => ReceivedNotifyModel(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['summary'] == null
          ? MessageType.problem
          : (map['summary'] as String).toMessageType(),
      date: map['date'] ?? DateTime.now(),
      isOpened: map['isOpened'] ?? false,
      buttonKeyPressed: map['buttonKeyPressed'] ?? '',
    );
  ReceivedNotifyModel copyWith(bool? isOpened) => ReceivedNotifyModel(
        id: id,
        title: title,
        body: body,
        date: date,
        from: from,
        to: to,
        isOpened: isOpened ?? this.isOpened,
        type: type,
        buttonKeyPressed: buttonKeyPressed,
      );
  toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'summary': type?.toStringVal(),
      };
}
