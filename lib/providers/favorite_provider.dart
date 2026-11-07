// lib/providers/favorite_provider.dart
import 'package:flutter/foundation.dart';
import '../core/app_exception.dart';
import '../models/saved_recipe.dart';
import '../repositories/saved_recipe_repository.dart';
import 'recipe_provider.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider(this._repo);
  final SavedRecipeRepository _repo;

  LoadStatus status = LoadStatus.idle;
  String? errorMessage;
  List<SavedRecipe> items = [];

  bool isSaved(String mealId) => items.any((e) => e.mealId == mealId);

  SavedRecipe? findByMealId(String mealId) {
    for (final e in items) {
      if (e.mealId == mealId) return e;
    }
    return null;
  }

  Future<void> load() async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      items = await _repo.getAll();
      status = LoadStatus.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> add(SavedRecipe recipe) async {
    final created = await _repo.create(recipe);
    items = [created, ...items];
    notifyListeners();
  }

  Future<void> update(SavedRecipe recipe) async {
    final updated = await _repo.update(recipe);
    items = [for (final e in items) e.id == updated.id ? updated : e];
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    items = items.where((e) => e.id != id).toList();
    notifyListeners();
  }
}