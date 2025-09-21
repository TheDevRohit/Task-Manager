import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final newMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', newMode == ThemeMode.dark);
  }
}
