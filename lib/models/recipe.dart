// lib/models/recipe.dart
class Ingredient {
  const Ingredient({required this.name, required this.measure});
  final String name;
  final String measure;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
    this.instructions,
    this.youtube,
    this.ingredients = const [],
  });

  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final String? youtube;
  final List<Ingredient> ingredients;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    // Loop 1..20 untuk mengumpulkan bahan dari format API TheMealDB
    for (var i = 1; i <= 20; i++) {
      final name = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }
    return Recipe(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
      youtube: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }

  /// Memecah teks instruksi menjadi daftar langkah bernomor
  List<String> get steps => (instructions ?? '')
      .split(RegExp(r'\r?\n'))
      .map((s) => s.trim())
      .where((s) => s.length > 3)
      .toList();
}