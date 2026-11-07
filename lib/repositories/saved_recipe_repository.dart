// lib/repositories/saved_recipe_repository.dart
import '../core/constants.dart';
import '../models/saved_recipe.dart';
import '../services/saved_recipe_service.dart';

class SavedRecipeRepository {
  SavedRecipeRepository(this._service);
  final SavedRecipeService _service;

  Future<List<SavedRecipe>> getAll() async =>
      (await _service.fetchAll(AppConstants.studentId)).map(SavedRecipe.fromMap).toList();

  Future<SavedRecipe> create(SavedRecipe r) async =>
      SavedRecipe.fromMap(await _service.insert(r.toMap()));

  Future<SavedRecipe> update(SavedRecipe r) async =>
      SavedRecipe.fromMap(await _service.update(r.id!, r.toMap()));

  Future<void> delete(String id) => _service.delete(id);
}