import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/database_service.dart';
import '../../../data/models/history_model.dart';
import 'package:intl/intl.dart'; // Add 'intl: ^0.18.1' to pubspec.yaml for date formatting

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _confirmClearHistory(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to delete all your quiz history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog

              // Call the database service to clear data
              await DatabaseService().deleteUserHistory(userId);

              // Show a success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History cleared successfully!'),
                  ),
                );
              }
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear History',
              onPressed: () => _confirmClearHistory(context, user.uid),
            ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please log in'))
          : StreamBuilder<List<HistoryModel>>(
              stream: DatabaseService().getUserHistory(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No history found. Play a quiz!'),
                  );
                }

                final historyList = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final data = historyList[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            '${data.score}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          '${data.category} Quiz',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Correct: ${data.correct} | Incorrect: ${data.incorrect}\n'
                          'Time: ${data.timeTaken}s | Skipped: ${data.skipped}',
                        ),
                        trailing: Text(
                          DateFormat(
                            'MMM dd, yy',
                          ).format(data.date), // Requires 'intl' package
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
