import 'package:equatable/equatable.dart';
import 'package:task_manager/data/models/task/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  final TaskStatus? filter;

  const TasksLoaded(this.tasks, this.filter);

  @override
  List<Object> get props => [tasks, filter ?? ''];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}