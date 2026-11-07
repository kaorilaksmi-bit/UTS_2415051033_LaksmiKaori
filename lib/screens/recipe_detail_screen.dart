// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/recipe.dart';
import '../models/saved_recipe.dart';
import '../providers/favorite_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/meal_api_service.dart';
import '../widgets/favorite_form_sheet.dart';
import '../widgets/state_views.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.mealId});
  final String mealId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _repo = RecipeRepository(MealApiService());
  Recipe? _recipe;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await _repo.detail(widget.mealId);
      setState(() {
        _recipe = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat detail resep';
        _isLoading = false;
      });
    }
  }

  void _openFavoriteForm(BuildContext context, FavoriteProvider favProvider, SavedRecipe? existing) async {
    if (_recipe == null) return;
    
    final SavedRecipe? result = await showModalBottomSheet<SavedRecipe>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FavoriteFormSheet(recipe: _recipe!, initialSaved: existing),
    );

    if (result != null && context.mounted) {
      if (existing == null) {
        await favProvider.add(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resep berhasil disimpan ke Favorit!')),
          );
        }
      } else {
        await favProvider.update(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catatan favorit diperbarui!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final savedData = favProvider.findByMealId(widget.mealId);
    final isFav = savedData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe?.name ?? 'Detail Resep'),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            onPressed: () {
              if (isFav) {
                favProvider.remove(savedData.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dihapus dari favorit')),
                );
              } else {
                _openFavoriteForm(context, favProvider, null);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _fetchDetail)
              : _recipe == null
                  ? const EmptyView(title: 'Resep tidak ditemukan', subtitle: '')
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Resep
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _recipe!.thumbnail,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 220,
                                color: Colors.grey[200],
                                child: const Icon(Icons.restaurant, size: 50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Judul & Kategori
                          Text(
                            _recipe!.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_recipe!.category ?? ''} • ${_recipe!.area ?? ''}',
                            style: const TextStyle(color: AppColors.muted, fontSize: 14),
                          ),
                          const SizedBox(height: 16),

                          // Section Bahan-bahan
                          const Text('Bahan-Bahan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._recipe!.ingredients.map(
                            (ing) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text('${ing.name} (${ing.measure})'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section Instruksi
                          const Text('Langkah Memasak:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(_recipe!.instructions ?? 'Tidak ada instruksi.'),
                        ],
                      ),
                    ),
      floatingActionButton: isFav
          ? FloatingActionButton.extended(
              onPressed: () => _openFavoriteForm(context, favProvider, savedData),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Catatan'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}