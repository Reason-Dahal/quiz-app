import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/database_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      // ❌ IMPORTANT FIX: removed overlap issue
      extendBodyBehindAppBar: true,

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffa1c4fd), Color(0xffc2e9fb), Color(0xfffbc2eb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: FutureBuilder(
            future: _databaseService.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Error occurred while fetching categories",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final categories = snapshot.data ?? [];

              if (categories.isEmpty) {
                return const Center(
                  child: Text(
                    "No categories found",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),

                      leading: const CircleAvatar(
                        backgroundColor: Color(0xff66A6FF),
                        child: Icon(Icons.category, color: Colors.white),
                      ),

                      title: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),

                      onTap: () {
                        // handle category click
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
