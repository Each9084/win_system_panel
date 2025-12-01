//该Controller 来管理当前的主题模式，并处理本地存储

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<ThemeMode> {
  //默认使用深色模式
  ThemeController() : super(ThemeMode.dark) {
    _loadThemeMode(); // 初始化时加载存储的主题模式
  }

  static const _themeKey = "appThemeMode"; // SharedPreferences 的键

  //从本地加载SharedPreferences主题模式
  Future<void> _loadThemeMode() async {
    // 单例模式
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);

    //如果本地有存储，则应用存储的主题
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    } else {
      // 否则使用系统主题或默认深色
      // state = ThemeMode.system; // 如果要跟随系统
      state = ThemeMode.dark;
    }
  }

// 切换主题模式并保存到本地
  void toggleTheme() {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newTheme;
    _saveThemeMode(newTheme);
  }

  // 保存主题模式到本地
  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    //使用 index 来存储枚举值 (0: system, 1: light, 2: dark)
    prefs.setInt(_themeKey, mode.index);
  }
}
