import "package:flutter/material.dart";
import "package:quiz_app/core/services/auth_service.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthScreen> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _authService = AuthService();

  bool islogin = true;
  bool isloading = false;

  void signUp() async {
    if (!formKey.currentState!.validate()) return;
    setState(() {
      isloading = true;
    });
    try {
      if (islogin) {
        await _authService.signIn(_email.text.trim(), _password.text.trim());

        final roleDoc = await FirebaseFirestore.instance
            .collection('usersRole')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        final role = (roleDoc.data() as Map<String, dynamic>)['role'];

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          role == "admin" ? "/admin" : "/home",
          (route) => false,
        );
      } else {
        await _authService.signUp(_email.text.trim(), _password.text.trim());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
              'username': _email.text.split('@')[0],
              'email': _email.text.trim(),
              'createdAt': FieldValue.serverTimestamp(),
            });

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    if (mounted) {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  islogin ? "Login" : "Sign Up",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter username";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                isloading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: signUp,
                          child: Text(
                            islogin ? "login" : "signup",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => setState(() {
                    islogin = !islogin;
                  }),
                  child: Text(
                    islogin ? 'Create an account' : 'I already have an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
