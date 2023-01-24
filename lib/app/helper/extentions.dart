import 'package:flutter/material.dart';
import '../utils/color_manager.dart';
import '../utils/strings_manager.dart';
import 'enums.dart';

extension PriorityConversion on TaskPriority {
  int toInt() {
    switch (this) {
      case TaskPriority.high:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 3;
    }
  }

  Color toColor() {
    switch (this) {
      case TaskPriority.high:
        return ColorManager.kRed;
      case TaskPriority.medium:
        return ColorManager.kOrange;
      case TaskPriority.low:
        return ColorManager.kYellow;
    }
  }
}

extension IntConversion on int {
  TaskPriority toPriority() {
    if (this == 1) {
      return TaskPriority.high;
    } else if (this == 2) {
      return TaskPriority.medium;
    } else {
      return TaskPriority.low;
    }
  }
}

extension DateConversion on DateTime {
  String toClock() {
    int hour = this.hour;
    String min = minute < 10 ? '0$minute' : '$minute';
    if (hour > 12) {
      return '${hour - 12}:$min';
    } else if (hour > 24) {
      return '${hour - 24}:$min';
    } else if (hour == 0) {
      return '12:$min';
    } else {
      return '$hour:$min';
    }
  }

  String toHourMark() {
    int hour = this.hour;
    if (hour > 12) {
      return AppStrings.pm;
    } else if (hour > 24) {
      return AppStrings.am;
    } else {
      return AppStrings.am;
    }
  }

  int firstDayOfWeek() {
    var date = this;
    var weekDay = date.weekday;
    var firstDayOfWeek = date.subtract(Duration(days: weekDay));
    return firstDayOfWeek.day + 1;
  }

  DateTime zeroTime() => DateTime(year, month, day, 0, 0).toUtc();
}

extension StringConversion on String {
  MessageType toMessageType() {
    if (this == 'text') {
      return MessageType.text;
    } else if (this == 'voice') {
      return MessageType.voice;
    } else if (this == 'task') {
      return MessageType.task;
    } else if (this == 'problem') {
      return MessageType.problem;
    } else {
      return MessageType.pic;
    }
  }
}

extension MessageTypeConversion on MessageType {
  String toStringVal() {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.voice:
        return 'voice';
      case MessageType.pic:
        return 'pic';
      case MessageType.task:
        return 'task';
      case MessageType.problem:
        return 'problem';
    }
  }
}
