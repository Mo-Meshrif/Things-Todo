import 'package:equatable/equatable.dart';
import '../../../../app/helper/enums.dart';

class TaskTodo extends Equatable {
  final int? id;
  final String name;
  final String description;
  final String category;
  final String date;
  final TaskPriority priority;
  final bool important;
  final bool done;
  final bool later;
  final int speicalKey;

  const TaskTodo({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    required this.priority,
    required this.important,
    this.done = false,
    this.later = false,
    required this.speicalKey,
  });

  TaskTodo copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? date,
    TaskPriority? priority,
    bool? important,
    bool? done,
    bool? later,
    int? speicalKey,
  }) =>
      TaskTodo(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        date: date ?? this.date,
        priority: priority ?? this.priority,
        important: important ?? this.important,
        done: done ?? this.done,
        later: later ?? this.later,
        speicalKey: speicalKey ?? this.speicalKey,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        date,
        priority,
        important,
        done,
        later,
        speicalKey,
      ];
}
