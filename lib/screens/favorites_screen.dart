// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../models/recipe.dart';
import '../models/saved_recipe.dart';
import '../providers/favorite_provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/state_views.dart';
import 'favorite_form_screen.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Favorit Saya'),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          switch (provider.status) {
            case LoadStatus.idle:
            case LoadStatus.loading:
              return const LoadingView();
            case LoadStatus.error:
              return ErrorView(
                message: provider.errorMessage ?? 'Gagal memuat favorit',
                onRetry: provider.load,
              );
            case LoadStatus.success:
              if (provider.items.isEmpty) {
                return const EmptyView(
                  title: 'Belum Ada Resep Favorit',
                  subtitle: 'Simpan resep impianmu dari beranda atau pencarian',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.thumbnail ?? '',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.restaurant),
                        ),
                      ),
                      title: Text(item.mealName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < item.rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          if (item.note != null && item.note!.isNotEmpty)
                            Text(
                              'Catatan: ${item.note}',
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_note, color: AppColors.primary),
                            onPressed: () async {
                              final recipeProv = context.read<RecipeProvider>();
                              final recipeObj = recipeProv.recipes.firstWhere(
                                (r) => r.id == item.mealId,
                                orElse: () => itemToRecipe(item),
                              );

                              // Menggunakan Navigator.push ke FavoriteFormScreen (Screen Penuh)
                              final result = await Navigator.push<SavedRecipe>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FavoriteFormScreen(
                                    recipe: recipeObj,
                                    initialSaved: item,
                                  ),
                                ),
                              );

                              if (result != null && context.mounted) {
                                await provider.update(result);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () async {
                              // Menampilkan AlertDialog Konfirmasi Hapus (Kriteria 5)
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Konfirmasi Hapus'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus resep ini dari favorit?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );

                              // Eksekusi penghapusan hanya jika pengguna menekan tombol "Hapus"
                              if (confirm == true && context.mounted) {
                                await provider.remove(item.id!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Resep berhasil dihapus dari favorit'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(mealId: item.mealId),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

// Helper perubah SavedRecipe ke Recipe sederhana
Recipe itemToRecipe(SavedRecipe item) => Recipe(
      id: item.mealId,
      name: item.mealName,
      thumbnail: item.thumbnail ?? '',
      category: item.category,
    );