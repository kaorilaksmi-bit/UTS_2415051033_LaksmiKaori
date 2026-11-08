// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../core/app_colors.dart';
import '../models/recipe.dart';
import '../models/saved_recipe.dart';
import '../providers/favorite_provider.dart';
import '../repositories/recipe_repository.dart';
import '../services/meal_api_service.dart';
import '../widgets/state_views.dart';
import 'favorite_form_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.mealId});
  final String mealId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _repo = RecipeRepository(MealApiService());
  final _translator = GoogleTranslator();

  Recipe? _recipe;
  bool _isLoading = true;
  String? _error;

  List<String> _translatedIngredients = [];
  List<String> _translatedSteps = [];

  @override
  void initState() {
    super.initState();
    _fetchAndTranslateDetail();
  }

  Future<void> _fetchAndTranslateDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final res = await _repo.detail(widget.mealId);
      _recipe = res;

      if (_recipe != null) {
        // 1. Terjemahkan Bahan-bahan secara paralel
        final ingFutures = _recipe!.ingredients.map((ing) async {
          final text = '${ing.name} (${ing.measure})';
          try {
            final translation = await _translator.translate(text, to: 'id');
            return translation.text;
          } catch (_) {
            return text; // Fallback jika koneksi terjemahan terganggu
          }
        });
        _translatedIngredients = await Future.wait(ingFutures);

        // 2. Bersihkan & Terjemahkan Langkah Memasak
        if (_recipe!.instructions != null && _recipe!.instructions!.trim().isNotEmpty) {
          final rawSteps = _recipe!.instructions!
              .split(RegExp(r'\r?\n|\d+\.\s*'))
              .where((s) => s.trim().length > 2)
              .toList();

          final stepFutures = rawSteps.map((step) async {
            try {
              final translation = await _translator.translate(step.trim(), to: 'id');
              return translation.text;
            } catch (_) {
              return step.trim();
            }
          });
          _translatedSteps = await Future.wait(stepFutures);
        }
      }

      setState(() {
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
    
    // Membuka FavoriteFormScreen sebagai Route Halaman Penuh via Navigator.push
    final SavedRecipe? result = await Navigator.push<SavedRecipe>(
      context,
      MaterialPageRoute(
        builder: (_) => FavoriteFormScreen(recipe: _recipe!, initialSaved: existing),
      ),
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
              ? ErrorView(message: _error!, onRetry: _fetchAndTranslateDetail)
              : _recipe == null
                  ? const EmptyView(title: 'Resep tidak ditemukan', subtitle: '')
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                          Text(
                            _recipe!.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_recipe!.category ?? ''} • ${_recipe!.area ?? ''}',
                            style: const TextStyle(color: AppColors.muted, fontSize: 14),
                          ),
                          const SizedBox(height: 20),

                          // Section Bahan-bahan (Otomatis Terjemah)
                          const Text('Bahan-Bahan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._translatedIngredients.map(
                            (ingText) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ingText,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Section Langkah Memasak (Otomatis Terjemah & Penomoran Rapi 1, 2, 3...)
                          const Text('Langkah Memasak:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          if (_translatedSteps.isEmpty)
                            const Text('Tidak ada instruksi langkah memasak.')
                          else
                            ..._translatedSteps.asMap().entries.map((entry) {
                              final index = entry.key + 1;
                              final stepText = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$index',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        stepText,
                                        style: const TextStyle(fontSize: 14, height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
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