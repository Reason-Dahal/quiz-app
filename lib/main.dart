import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/core/routes/app_router.dart';
import 'package:quiz_app/core/services/auth_service.dart';
import 'package:quiz_app/ui/screens/admin/admin_screen.dart';
import 'package:quiz_app/ui/screens/auth/auth_screen.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      onGenerateRoute: AppRouter.generate,

      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return const AuthScreen();
          }
          final user = snapshot.data;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("usersRole")
                .doc(user!.uid)
                .get(),

            builder: (context, roleData) {
              if (roleData.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (!roleData.hasData || !roleData.data!.exists) {
                return const AuthScreen();
              }

              final data = roleData.data!.data() as Map<String, dynamic>;

              final role = data['role'];

              if (role == "admin") {
                return const AdminScreen();
              }

              return HomeScreen();
            },
          );
        },
      ),
    );
  }
}
