// lib/providers/favorite_provider.dart
import 'package:flutter/foundation.dart';
import '../models/saved_recipe.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<SavedRecipe> _items = [];

  List<SavedRecipe> get items => List.unmodifiable(_items);

  bool isSaved(String mealId) {
    return _items.any((item) => item.mealId == mealId);
  }

  void toggleFavorite(SavedRecipe recipe) {
    final index = _items.indexWhere((item) => item.mealId == recipe.mealId);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(recipe);
    }
    notifyListeners();
  }
}