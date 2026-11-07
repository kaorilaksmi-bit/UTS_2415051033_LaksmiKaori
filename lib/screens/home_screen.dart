// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Data dummy menggunakan model Recipe dengan URL gambar CORS-friendly
  static final List<Recipe> _dummyRecipes = [
    const Recipe(
      id: '52772',
      name: 'Teriyaki Chicken Casserole',
      thumbnail: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
      category: 'Chicken',
      area: 'Japanese',
    ),
    const Recipe(
      id: '52768',
      name: 'Double Cheeseburger',
      thumbnail: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      category: 'Dessert',
      area: 'British',
    ),
    const Recipe(
      id: '52804',
      name: 'Bacon Burger',
      thumbnail: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=500',
      category: 'Miscellaneous',
      area: 'Canadian',
    ),
    const Recipe(
      id: '52977',
      name: 'Corba',
      thumbnail: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=500',
      category: 'Side',
      area: 'Turkish',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Header Gradient
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
                // Header Sapaan & User Info
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
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                const SearchField(),
                const SizedBox(height: 24),

                // Section Judul: Populer Hari Ini
                const Text(
                  'Populer Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Grid Responsif dengan Objek Model Recipe
                RecipeGrid(
                  itemCount: _dummyRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _dummyRecipes[index];
                    return RecipeCard(
                      title: recipe.name,
                      subtitle: '${recipe.category ?? ''} • ${recipe.area ?? ''}',
                      imageUrl: recipe.thumbnail,
                      onTap: () {},
                    );
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