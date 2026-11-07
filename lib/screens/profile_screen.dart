// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../core/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text(AppConstants.studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(AppConstants.studentId, style: const TextStyle(color: Colors.grey)),
            Text(AppConstants.className, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}