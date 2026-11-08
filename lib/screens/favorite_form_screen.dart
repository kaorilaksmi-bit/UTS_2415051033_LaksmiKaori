// lib/screens/favorite_form_screen.dart
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../models/recipe.dart';
import '../models/saved_recipe.dart';

class FavoriteFormScreen extends StatefulWidget {
  const FavoriteFormScreen({
    super.key,
    required this.recipe,
    this.initialSaved,
  });

  final Recipe recipe;
  final SavedRecipe? initialSaved;

  @override
  State<FavoriteFormScreen> createState() => _FavoriteFormScreenState();
}

class _FavoriteFormScreenState extends State<FavoriteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _noteController;
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final saved = SavedRecipe(
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

      Navigator.pop(context, saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialSaved != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan Favorit' : 'Simpan ke Favorit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Singkat Resep
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.recipe.thumbnail,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.restaurant),
                    ),
                  ),
                  title: Text(
                    widget.recipe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.recipe.category ?? 'Resep Kuliner'),
                ),
              ),

              // Rating Stars
              const Text('Rating Kamu:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input Catatan dengan TextFormField & Validator (Kriteria 8)
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan Pribadi (Wajib diisi)',
                  hintText: 'Misal: Kurangi garam, pakai api kecil...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan pribadi wajib diisi!';
                  }
                  if (value.trim().length < 3) {
                    return 'Catatan minimal 3 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Checkbox Sudah Dimasak
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sudah Pernah Dimasak?'),
                value: _isCooked,
                onChanged: (val) => setState(() => _isCooked = val ?? false),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submit,
                  child: Text(isEdit ? 'Perbarui Catatan' : 'Simpan Resep'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}