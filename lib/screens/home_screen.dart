// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/search_field.dart';
import '../widgets/state_views.dart';
import 'profile_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gradientTop, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${AppConstants.studentName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Mau masak apa hari ini?',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                      ],
                    ),
                    // Ikon profil sekarang bisa diklik untuk membuka Halaman Profil
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SearchField(
                  onChanged: (val) => context.read<RecipeProvider>().setQuery(val.trim()),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Populer Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Consumer<RecipeProvider>(
                  builder: (context, provider, _) {
                    switch (provider.status) {
                      case LoadStatus.idle:
                      case LoadStatus.loading:
                        return const SizedBox(height: 200, child: LoadingView());
                      case LoadStatus.error:
                        return ErrorView(
                          message: provider.errorMessage ?? 'Gagal memuat resep',
                          onRetry: provider.loadRecipes,
                        );
                      case LoadStatus.success:
                        if (provider.recipes.isEmpty) {
                          return const EmptyView(
                            title: 'Resep Tidak Ditemukan',
                            subtitle: 'Coba kata kunci pencarian lain',
                          );
                        }
                        return RecipeGrid(
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
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}