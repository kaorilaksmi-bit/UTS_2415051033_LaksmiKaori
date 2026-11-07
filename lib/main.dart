import 'package:flutter/material.dart';
import 'core/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Selamat Datang di ${AppConstants.appName}!'),
        ),
      ),
    );
  }
}