// lib/providers/recipe_provider.dart
import 'package:flutter/foundation.dart';
import '../core/app_exception.dart';
import '../models/recipe.dart';
import '../models/recipe_category.dart';
import '../repositories/recipe_repository.dart';

enum LoadStatus { idle, loading, success, error }

class RecipeProvider extends ChangeNotifier {
  RecipeProvider(this._repo);
  final RecipeRepository _repo;

  LoadStatus status = LoadStatus.idle;
  String? errorMessage;
  List<Recipe> recipes = [];
  List<RecipeCategory> categories = [];
  String selectedCategory = 'Semua';
  String query = '';

  Future<void> loadRecipes() async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      if (categories.isEmpty) {
        categories = await _repo.categories();
      }
      
      if (query.isNotEmpty) {
        recipes = await _repo.search(query);
      } else if (selectedCategory == 'Semua') {
        recipes = await _repo.search('chicken'); // Default kata kunci saat awal
      } else {
        recipes = await _repo.byCategory(selectedCategory);
      }
      status = LoadStatus.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      status = LoadStatus.error;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan tidak terduga';
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    query = '';
    loadRecipes();
  }

  void setQuery(String value) {
    query = value;
    loadRecipes();
  }
}