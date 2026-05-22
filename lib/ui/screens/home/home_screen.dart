import 'package:flutter/material.dart';
import 'package:quizapp/core/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: const Center(child: Text("Home Screen")),
    );
  }
}
