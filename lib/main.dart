// lib/main.dart
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/constants.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ResepKuApp());
}

class ResepKuApp extends StatelessWidget {
  const ResepKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomeScreen(),
    );
  }
}