import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'app_theme_mode';
  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key) ?? 'system';
    if (value == 'light') {
      emit(ThemeMode.light);
    } else if (value == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setTheme(newTheme);
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString().split('.').last);
    emit(mode);
  }
}
