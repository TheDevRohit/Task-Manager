import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/bloc/task/task_state.dart';
import 'package:task_manager/data/cubit/theme_cubit.dart';
import 'package:task_manager/data/models/task/task_model.dart';
import 'package:task_manager/presentation/pages/task_form.dart';
import 'package:task_manager/presentation/widgets/no_data.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leadingWidth: 50,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 4, bottom: 4),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvZRzCOTmTpG-0zKoHeoNr8J-LeI_ihfZO3Q&s'), // user avatar
          ),
        ),
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, Rohit 👋",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text("Your Dashboard",
                style: TextStyle(
                  color:  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
            )),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
                  color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          filterMenuWidget(context),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          } else if (state is TasksLoaded) {
            final tasks = state.tasks;
            if (tasks.isEmpty) {
              return NoDataFound(filter: state.filter);
            }
            return SingleChildScrollView(
              child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<TaskBloc>().add(const LoadTasks());
                  },
                  child: Column(
                    children: [
                      buildSummary(tasks),
                      buildProgress(tasks),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        itemCount: tasks.length,
                        onReorder: (oldIndex, newIndex) {
                          onReorder(context, oldIndex, newIndex, tasks);
                        },
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: ValueKey(task.id),
                            background: Container(
                              padding: const EdgeInsets.only(left: 16),
                              alignment: Alignment.centerLeft,
                              color: Colors.green,
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              padding: const EdgeInsets.only(right: 16),
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Swipe left → Edit
                                editTask(context, task);
                                return false; // Don't remove the item
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                deleteTask(context, task.id);
                              }
                              return false;
                            },
                            child: TaskCard(
                              task: task,
                              onEdit: (task) => editTask(context, task),
                              onDelete: (id) => deleteTask(context, id),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
            );
          } else if (state is TaskError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(const LoadTasks());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTask(context),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
    );
  }

  Widget filterMenuWidget(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        TaskStatus? currentFilter;
        if (state is TasksLoaded) {
          currentFilter = state.filter;
        }

        return PopupMenuButton<TaskStatus?>(
          onSelected: (filter) {
            context.read<TaskBloc>().add(ChangeFilter(filter));
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskStatus?>>[
            PopupMenuItem<TaskStatus?>(
              value: null,
              onTap: () {
                context.read<TaskBloc>().add(const LoadTasks());
              },
              child: Row(
                children: [
                  Icon(Icons.all_inclusive,
                      color: currentFilter == null ? Colors.blue : Colors.grey),
                  const SizedBox(width: 8),
                  Text('All Tasks',
                      style: TextStyle(
                          color: currentFilter == null
                              ? Colors.blue
                              :  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,)),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<TaskStatus?>(
              value: TaskStatus.todo,
              child: Row(
                children: [
                  Icon(Icons.circle_outlined,
                      color: currentFilter == TaskStatus.todo
                          ? Colors.orange
                          : Colors.grey),
                  const SizedBox(width: 8),
                  Text('To Do',
                      style: TextStyle(
                          color: currentFilter == TaskStatus.todo
                              ? Colors.orange
                              :  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,)),
                ],
              ),
            ),
            PopupMenuItem<TaskStatus?>(
              value: TaskStatus.inProgress,
              child: Row(
                children: [
                  Icon(Icons.autorenew,
                      color: currentFilter == TaskStatus.inProgress
                          ? Colors.blue
                          : Colors.grey),
                  const SizedBox(width: 8),
                  Text('In Progress',
                      style: TextStyle(
                          color: currentFilter == TaskStatus.inProgress
                              ? Colors.blue
                              :  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,)),
                ],
              ),
            ),
            PopupMenuItem<TaskStatus?>(
              value: TaskStatus.done,
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: currentFilter == TaskStatus.done
                          ? Colors.green
                          : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Done',
                      style: TextStyle(
                          color: currentFilter == TaskStatus.done
                              ? Colors.green
                              : Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,)),
                ],
              ),
            ),
          ],
          icon:  Icon(Icons.filter_alt_outlined, color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black  ,),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }

  void _addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<TaskBloc>(context),
          child: AddEditTaskScreen(
            onSave: (task) {
              BlocProvider.of<TaskBloc>(context).add(AddTask(task));
            },
          ),
        ),
      ),
    ).then((_) {
      context.read<TaskBloc>().add(const LoadTasks());
    });
  }

  void editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<TaskBloc>(context),
          child: AddEditTaskScreen(
            task: task,
            onSave: (updatedTask) {
              BlocProvider.of<TaskBloc>(context).add(UpdateTask(updatedTask));
            },
          ),
        ),
      ),
    ).then((_) {
      context.read<TaskBloc>().add(const LoadTasks());
    });
  }

  void deleteTask(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Delete Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to delete this task?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(DeleteTask(id));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.read<TaskBloc>().add(const LoadTasks());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void onReorder(
    BuildContext context, int oldIndex, int newIndex, List<Task> tasks) {
  if (newIndex > oldIndex) newIndex -= 1;
  final task = tasks.removeAt(oldIndex);
  tasks.insert(newIndex, task);

  context.read<TaskBloc>().add(const LoadTasks());
}

Widget buildSummary(List<Task> tasks) {
  int todo = tasks.where((t) => t.status == TaskStatus.todo).length;
  int inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
  int done = tasks.where((t) => t.status == TaskStatus.done).length;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        statusCardWidget("Todo", todo, Colors.orange, Icons.pending_actions),
        const SizedBox(width: 12),
        statusCardWidget(
            "In Progress", inProgress, Colors.blue, Icons.autorenew),
        const SizedBox(width: 12),
        statusCardWidget("Done", done, Colors.green, Icons.check_circle),
      ],
    ),
  );
}

Widget statusCardWidget(String title, int count, Color color, IconData icon) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text("$count",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(title,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ),
  );
}

Widget buildProgress(List<Task> tasks) {
  if (tasks.isEmpty) return const SizedBox();
  int done = tasks.where((t) => t.status == TaskStatus.done).length;
  double progress = done / tasks.length;

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
              Text("${(progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Overall Progress",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("$done of ${tasks.length} tasks completed",
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
