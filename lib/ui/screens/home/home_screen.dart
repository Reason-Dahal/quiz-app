import 'package:flutter/material.dart';
import 'package:quizapp/core/services/auth_service.dart';
import 'package:quizapp/core/services/database_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Category"),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),

      body: FutureBuilder<List<String>>(
        future: _databaseService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return Center(
              child: Text(
                "No Categories. Please enter the categories on the database.",
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.deepPurple,
                    size: 36,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/quiz', arguments: category);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
