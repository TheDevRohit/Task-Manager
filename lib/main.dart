import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/constants/theme/app_theme.dart';
import 'package:task_manager/data/repo/task_repo.dart';
import 'package:task_manager/presentation/pages/task_list_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository = TaskRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository)..add(const LoadTasks()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: AppThemes.lightTheme,
        themeMode: ThemeMode.dark ,
        title: 'Task Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}