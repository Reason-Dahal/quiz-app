import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authService.signOut();
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
