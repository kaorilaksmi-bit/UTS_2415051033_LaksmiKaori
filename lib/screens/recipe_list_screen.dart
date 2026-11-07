// lib/screens/recipe_list_screen.dart
import 'package:flutter/material.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Resep')),
      body: const Center(child: Text('Layar Pencarian & Filter Resep')),
    );
  }
}