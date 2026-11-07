// lib/models/recipe_category.dart
class RecipeCategory {
  const RecipeCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  final String id;
  final String name;
  final String thumbnail;

  factory RecipeCategory.fromJson(Map<String, dynamic> json) => RecipeCategory(
        id: json['idCategory'] as String,
        name: json['strCategory'] as String,
        thumbnail: json['strCategoryThumb'] as String? ?? '',
      );
}