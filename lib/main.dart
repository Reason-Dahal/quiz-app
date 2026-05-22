import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/auth_service.dart';
import 'package:quiz_app/ui/screens/auth/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizApp',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ),
//       body: AuthScreen (),
//     );
//   }
// }
