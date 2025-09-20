import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/bloc/task/task_state.dart';
import 'package:task_manager/data/models/task/task_model.dart';
import 'package:task_manager/data/repo/task_repo.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskStatus? currentFilter;

  TaskBloc(this.taskRepository) : super(TasksLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ChangeFilter>(_onChangeFilter);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRepository.getTasks();
      currentFilter = event.filter;
      final filteredTasks = _filterTasks(tasks, event.filter);
      emit(TasksLoaded(filteredTasks, event.filter));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      final tasks = await taskRepository.getTasks();
      final filteredTasks = _filterTasks(tasks, currentFilter);
      emit(TasksLoaded(filteredTasks, currentFilter));
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      final tasks = await taskRepository.getTasks();
      final filteredTasks = _filterTasks(tasks, currentFilter);
      emit(TasksLoaded(filteredTasks, currentFilter));
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.id);
      final tasks = await taskRepository.getTasks();
      final filteredTasks = _filterTasks(tasks, currentFilter);
      emit(TasksLoaded(filteredTasks, currentFilter));
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }

  Future<void> _onChangeFilter(ChangeFilter event, Emitter<TaskState> emit) async {
    try {
      final tasks = await taskRepository.getTasks();
      currentFilter = event.filter;
      final filteredTasks = _filterTasks(tasks, event.filter);
      emit(TasksLoaded(filteredTasks, event.filter));
    } catch (e) {
      emit(TaskError('Failed to filter tasks'));
    }
  }

  List<Task> _filterTasks(List<Task> tasks, TaskStatus? filter) {
    print("filter = $filter");
    if (filter == null) return tasks;
    return tasks.where((task) => task.status == filter).toList();
  }
}