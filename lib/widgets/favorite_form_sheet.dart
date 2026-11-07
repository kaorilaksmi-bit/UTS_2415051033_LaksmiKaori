// lib/widgets/favorite_form_sheet.dart
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../models/recipe.dart';
import '../models/saved_recipe.dart';

class FavoriteFormSheet extends StatefulWidget {
  const FavoriteFormSheet({
    super.key,
    required this.recipe,
    this.initialSaved,
  });

  final Recipe recipe;
  final SavedRecipe? initialSaved;

  @override
  State<FavoriteFormSheet> createState() => _FavoriteFormSheetState();
}

class _FavoriteFormSheetState extends State<FavoriteFormSheet> {
  late final TextEditingController _noteController;
  late int _rating;
  late bool _isCooked;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialSaved?.note ?? '');
    _rating = widget.initialSaved?.rating ?? 5;
    _isCooked = widget.initialSaved?.isCooked ?? false;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.initialSaved == null ? 'Simpan ke Favorit' : 'Edit Catatan Resep',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Rating Bintang (1-5)
          const Text('Rating Resep:', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return IconButton(
                icon: Icon(
                  starValue <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = starValue),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Input Catatan Pribadi
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Catatan Pribadi',
              hintText: 'Misal: Kurangi takaran gula atau tambah keju',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          // Checkbox Status Dimasak
          CheckboxListTile(
            title: const Text('Sudah Pernah Dimasak?'),
            value: _isCooked,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => setState(() => _isCooked = val ?? false),
          ),
          const SizedBox(height: 16),

          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final result = SavedRecipe(
                  id: widget.initialSaved?.id,
                  studentId: AppConstants.studentId,
                  mealId: widget.recipe.id,
                  mealName: widget.recipe.name,
                  thumbnail: widget.recipe.thumbnail,
                  category: widget.recipe.category,
                  note: _noteController.text.trim(),
                  rating: _rating,
                  isCooked: _isCooked,
                );
                Navigator.pop(context, result);
              },
              child: const Text('Simpan Ke Favorit'),
            ),
          ),
        ],
      ),
    );
  }
}