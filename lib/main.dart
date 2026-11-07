// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/constants.dart';
import 'providers/favorite_provider.dart';
import 'providers/recipe_provider.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const ResepKuApp());
}

class ResepKuApp extends StatelessWidget {
  const ResepKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()..loadRecipes()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const MainShell(),
      ),
    );
  }
}