// lib/repositories/recipe_repository.dart
import '../models/recipe.dart';
import '../models/recipe_category.dart';
import '../services/meal_api_service.dart';

class RecipeRepository {
  RecipeRepository(this._api);
  final MealApiService _api;

  Future<List<Recipe>> search(String q) async =>
      (await _api.search(q)).map(Recipe.fromJson).toList();

  Future<List<Recipe>> byCategory(String c) async =>
      (await _api.filterByCategory(c)).map(Recipe.fromJson).toList();

  Future<List<RecipeCategory>> categories() async =>
      (await _api.categories()).map(RecipeCategory.fromJson).toList();

  Future<Recipe?> detail(String id) async {
    final list = await _api.lookup(id);
    return list.isEmpty ? null : Recipe.fromJson(list.first);
  }
}