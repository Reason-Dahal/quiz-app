import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/admin/admin_screen.dart';
import 'package:quiz_app/ui/screens/auth/auth_screen.dart';
import 'package:quiz_app/ui/screens/history/history_screen.dart';
import 'package:quiz_app/ui/screens/home/categories_screen.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'package:quiz_app/ui/screens/quiz/quiz_screen.dart';
import 'package:quiz_app/ui/screens/result/result_screen.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminScreen());

      case '/categories':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case '/result':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(resultData: args),
        );
      case '/history':
        return MaterialPageRoute(builder: (_) => HistoryScreen());

      case '/quiz':
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => QuizScreen(category: category),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("Page not found"))),
        );
    }
  }
}
