// lib/models/saved_recipe.dart
class SavedRecipe {
  const SavedRecipe({
    this.id,
    required this.studentId,
    required this.mealId,
    required this.mealName,
    this.thumbnail,
    this.category,
    this.note,
    this.rating = 0,
    this.isCooked = false,
    this.createdAt,
  });

  final String? id; // null sebelum disimpan ke Supabase
  final String studentId;
  final String mealId;
  final String mealName;
  final String? thumbnail;
  final String? category;
  final String? note;
  final int rating;
  final bool isCooked;
  final DateTime? createdAt;

  factory SavedRecipe.fromMap(Map<String, dynamic> m) => SavedRecipe(
        id: m['id'] as String?,
        studentId: m['student_id'] as String,
        mealId: m['meal_id'] as String,
        mealName: m['meal_name'] as String,
        thumbnail: m['thumbnail'] as String?,
        category: m['category'] as String?,
        note: m['note'] as String?,
        rating: (m['rating'] as num?)?.toInt() ?? 0,
        isCooked: m['is_cooked'] as bool? ?? false,
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? ''),
      );

  Map<String, dynamic> toMap() => {
        'student_id': studentId,
        'meal_id': mealId,
        'meal_name': mealName,
        'thumbnail': thumbnail,
        'category': category,
        'note': note,
        'rating': rating,
        'is_cooked': isCooked,
      };

  SavedRecipe copyWith({String? note, int? rating, bool? isCooked}) => SavedRecipe(
        id: id,
        studentId: studentId,
        mealId: mealId,
        mealName: mealName,
        thumbnail: thumbnail,
        category: category,
        note: note ?? this.note,
        rating: rating ?? this.rating,
        isCooked: isCooked ?? this.isCooked,
        createdAt: createdAt,
      );
}