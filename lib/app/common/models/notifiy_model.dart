class NotifyActionModel {
  final int id;
  final String to, title, body;
  NotifyActionModel({
    required this.id,
    required this.to,
    required this.title,
    required this.body,
  });
}

class ReceivedNotifyModel {
  final int id;
  final String? title;
  final String? body;
  final String? type;
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

  factory ReceivedNotifyModel.fromJson(Map<String, dynamic> map) =>
      ReceivedNotifyModel(
        from: map['from'] ?? '',
        to: map['to'] ?? '',
        id: map['id'] ?? -1,
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        type: map['summary'] ?? '',
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
        'summary': type,
      };
}
