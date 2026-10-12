import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const IMShoyoApp());
}

class IMShoyoApp extends StatelessWidget {
  const IMShoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMShoyo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainShell(),
    );
  }
}