import 'package:equatable/equatable.dart';

enum TaskStatus {todo, inProgress, done }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [id, title, description, status, dueDate];
}