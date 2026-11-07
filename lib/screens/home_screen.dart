// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

                // Grid Responsif (Otomatis 2, 3, atau 4 kolom)
                RecipeGrid(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      title: 'Ayam Goreng Spesial $index',
                      subtitle: 'Chicken • Indonesian',
                      imageUrl: 'https://www.themealdb.com/images/media/meals/58omtl1618304657.jpg',
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