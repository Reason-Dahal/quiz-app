import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/auth/auth_screen.dart';
import 'package:quiz_app/ui/screens/home/categories_screen.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'package:quiz_app/ui/screens/quiz/quiz_screen.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/categories':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());

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
