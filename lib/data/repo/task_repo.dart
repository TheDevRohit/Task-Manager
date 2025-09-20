import 'package:task_manager/data/models/task/task_model.dart';

class TaskRepository {
  final List<Task> _tasks = [
  Task(
    id: '1',
    title: 'Complete Flutter Project',
    description: 'Finish the task manager app with all features using BLoC',
    status: TaskStatus.inProgress,
    dueDate: DateTime.now().add(const Duration(days: 3)),
  ),
  Task(
    id: '2',
    title: 'Buy Groceries',
    description: 'Milk, Eggs, Bread, Fruits',
    status: TaskStatus.todo,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  ),
  Task(
    id: '3',
    title: 'Call Mom',
    description: 'Weekly catch-up call',
    status: TaskStatus.done,
    dueDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Task(
    id: '4',
    title: 'Read a Book',
    description: 'Read 50 pages of a Flutter or programming book',
    status: TaskStatus.todo,
    dueDate: DateTime.now().add(const Duration(days: 5)),
  ),
];


  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}