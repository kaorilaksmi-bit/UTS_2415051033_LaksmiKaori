// lib/providers/recipe_provider.dart
import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../models/recipe_category.dart';

enum LoadStatus { idle, loading, success, error }

class RecipeProvider extends ChangeNotifier {
  // Status State
  LoadStatus status = LoadStatus.idle;
  String? errorMessage;

  // Data State
  List<Recipe> recipes = [];
  List<RecipeCategory> categories = [];
  String selectedCategory = 'Semua';
  String query = '';

  // Simulasi memuat data awal (akan dihubungkan ke REST API di Tahap 8)
  Future<void> loadRecipes() async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulasi jeda jaringan
      status = LoadStatus.success;
    } catch (e) {
      errorMessage = 'Gagal memuat data resep';
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }
}