import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/ui/screens/change_password/change_password_screen.dart';

class AccountDrawer extends StatefulWidget {
  const AccountDrawer({super.key});

  @override
  State<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  final _user = FirebaseAuth.instance.currentUser!;
  final _db = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final doc = await _db.collection('users').doc(_user.uid).get();
    if (doc.exists && mounted) {
      final username = doc.data()?['username'] ?? '';
      setState(() {
        _currentUsername = username;
        _usernameController.text = username;
      });
    }
  }

  Future<void> _saveUsername() async {
    final newName = _usernameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username cannot be empty')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _db.collection('users').doc(_user.uid).set({
        'username': newName,
      }, SetOptions(merge: true));
      setState(() {
        _currentUsername = newName;
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Username updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _cancelEdit() {
    setState(() {
      _usernameController.text = _currentUsername;
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _currentUsername.isNotEmpty
                    ? _currentUsername[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            accountName: const Text(''), // username shown below in edit row
            accountEmail: Text(
              _user.email ?? 'No email',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                _isEditing
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _usernameController,
                              autofocus: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  onPressed: _saveUsername,
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Save',
                                ),
                          IconButton(
                            onPressed: _cancelEdit,
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Cancel',
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              _currentUsername.isEmpty
                                  ? 'Tap edit to set a username'
                                  : _currentUsername,
                              style: TextStyle(
                                fontSize: 16,
                                color: _currentUsername.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _isEditing = true),
                            icon: const Icon(Icons.edit, size: 20),
                            tooltip: 'Edit username',
                          ),
                        ],
                      ),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("History"),
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
          ),

          const Divider(),

          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(child: Text("LogOut")),
                    content: Text("Do you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancle"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/auth",
                              (route) => false,
                            );
                          }
                        },
                        child: Text("LogOut"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
