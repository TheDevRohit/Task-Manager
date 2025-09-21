import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task/task_bloc.dart';
import 'package:task_manager/bloc/task/task_event.dart';
import 'package:task_manager/constants/theme/app_theme.dart';
import 'package:task_manager/data/cubit/theme_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TaskBloc(taskRepository)..add(const LoadTasks()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Manager',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            home: const TaskListScreen(),
          );
        },
      ),
    );
  }
}
