import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme_manager.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  // late bool isDark = false;
  late ThemeData themeData;

  bool isDark = false;
  // ThemeData themeData = ThemeManager.lightTheme;

  Future<void> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDark = prefs.getBool('theme') ?? false;
      themeData = isDark ? ThemeManager.darkTheme : ThemeManager.lightTheme;
      emit(ThemeChanged(themeData));
    } catch (e) {
      // إذا حدث خطأ، عيّن الثيم الافتراضي
      isDark = false;
      themeData = ThemeManager.lightTheme;
      emit(ThemeChanged(themeData));
    }
  }

  Future<void> switchTheme() async {
    isDark = !isDark;
    themeData = isDark ? ThemeManager.darkTheme : ThemeManager.lightTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', isDark);

    emit(ThemeChanged(themeData));
  }

  bool get currentThemeIsDark => isDark;
}
