import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// 主题文件

class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();

  // --- 默认配色 ---
  static const Color _scaffoldBackGround = Color(0xFF0F172A);

  // 卡片/表面色：稍亮的深灰色
  static const Color _surface = Color(0xFF1E293B);

  // 强调色：霓虹青 (Cyber Cyan) - 深色背景效果不错
  static const Color _primary = Color(0xFF00F0FF);

  // 次要强调色 用于辅助元素
  static const Color _secondary = Color(0xFF7C3AED);

  //报错颜色
  static const Color _error = Color(0xFFFF2B2B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _scaffoldBackGround,

      //定义颜色方案
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        secondary: _secondary,
        surface: _surface,
        error: _error,
        onPrimary: Colors.black, // 在霓虹色上的文字用黑色，对比度最高
      ),

      // 定义卡片样式
      cardTheme: CardTheme(
        color: _surface,
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _primary.withOpacity(0.1), width: 1), // 边框发光感
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  // --- 浅色主题定义 (新增) ---
  static const Color _scaffoldBackGroundLight = Color(0xFFF0F4F8);
  static const Color _surfaceLight = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _scaffoldBackGroundLight,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        secondary: _secondary,
        surface: _surfaceLight,
        background: _scaffoldBackGroundLight,
        error: _error,
        onPrimary: Colors.black,
        onSurface: Color(0xFF0F172A),
        onBackground: Color(0xFF0F172A),
      ),
      cardTheme: CardTheme(
        color: _surfaceLight,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        bodyMedium: TextStyle(color: Color(0xFF0F172A)),
      ),
      //其他组件颜色
      sliderTheme: const SliderThemeData(
        thumbColor: _primary,
        activeTrackColor: _primary,
        inactiveTrackColor: Color(0xFFD2E0F1),
      ),
    );
  }
}
