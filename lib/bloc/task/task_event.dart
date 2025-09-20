import 'package:equatable/equatable.dart';
import 'package:task_manager/data/models/task/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final TaskStatus? filter;

  const LoadTasks({this.filter});

  @override
  List<Object> get props => [filter ?? ''];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeFilter extends TaskEvent {
  final TaskStatus? filter;

  const ChangeFilter(this.filter);

  @override
  List<Object> get props => [filter ?? ''];
}