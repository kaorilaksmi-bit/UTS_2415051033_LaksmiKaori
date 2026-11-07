// lib/screens/recipe_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/search_field.dart';
import '../widgets/state_views.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Resep Kuliner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(
              onChanged: (val) => context.read<RecipeProvider>().setQuery(val.trim()),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<RecipeProvider>(
                builder: (context, provider, _) {
                  switch (provider.status) {
                    case LoadStatus.idle:
                    case LoadStatus.loading:
                      return const LoadingView();
                    case LoadStatus.error:
                      return ErrorView(
                        message: provider.errorMessage ?? 'Gagal memuat resep',
                        onRetry: provider.loadRecipes,
                      );
                    case LoadStatus.success:
                      if (provider.recipes.isEmpty) {
                        return const EmptyView(
                          title: 'Resep Tidak Ditemukan',
                          subtitle: 'Coba kata kunci masakan yang lain',
                        );
                      }
                      return ListView(
                        children: [
                          RecipeGrid(
                            itemCount: provider.recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = provider.recipes[index];
                              return RecipeCard(
                                title: recipe.name,
                                subtitle: recipe.category ?? 'Resep Kuliner',
                                imageUrl: recipe.thumbnail,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RecipeDetailScreen(mealId: recipe.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}