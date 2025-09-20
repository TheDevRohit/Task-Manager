import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task/task_model.dart';

class NoDataFound extends StatelessWidget {
  final TaskStatus? filter;

  const NoDataFound({super.key, this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;
    Color color;

    switch (filter) {
      case TaskStatus.todo:
        message = 'No tasks to do';
        icon = Icons.beach_access;
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        message = 'No tasks in progress';
        icon = Icons.autorenew;
        color = Colors.blue;
        break;
      case TaskStatus.done:
        message = 'No completed tasks';
        icon = Icons.celebration;
        color = Colors.green;
        break;
      default:
        message = 'No tasks yet';
        icon = Icons.assignment;
        color = Colors.grey;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: color.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first task',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
