import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/database_service.dart';
import 'package:quiz_app/ui/screens/admin/question_screen.dart';
import 'widgets/admin_drawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final DatabaseService db = DatabaseService();

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await db.getCategories();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> addCategory() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Category name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  await db.addCategory(controller.text.trim());

                  Navigator.pop(context);

                  loadCategories();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategory(String category) async {
    await db.deleteCategory(category);

    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),

      appBar: AppBar(title: const Text("Admin Dashboard")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addCategory,
        icon: const Icon(Icons.add),
        label: const Text("Category"),
      ),

      body: categories.isEmpty
          ? const Center(child: Text("No Categories"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(category),

                    leading: const CircleAvatar(child: Icon(Icons.category)),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.quiz),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    QuestionScreen(category: category),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteCategory(category);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
