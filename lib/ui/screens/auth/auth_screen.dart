import "package:flutter/material.dart";
import "package:quizapp/core/services/auth_service.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _authService = AuthService();

  bool isLogin = true;
  bool isLoading = false;

  void singUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (isLogin) {
        await _authService.signIn(_email.text.trim(), _password.text.trim());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login successfull")));
      } else {
        await _authService.signUp(_email.text.trim(), _password.text.trim());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Sign up successfull")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auth Screen Login/Signup")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _password,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: singUp,
                    child: Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin ? 'Create an account' : 'I already have an account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
