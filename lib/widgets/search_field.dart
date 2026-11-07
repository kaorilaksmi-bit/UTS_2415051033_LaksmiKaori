// lib/widgets/search_field.dart
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged, this.hintText = 'Cari resep favorit...'});

  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.muted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}