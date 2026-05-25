import "package:flutter/material.dart";
import "package:quizapp/ui/screens/auth/auth_screen.dart";
import "package:quizapp/ui/screens/home/home_screen.dart";
import "package:quizapp/ui/screens/quiz/quiz_screen.dart";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/quiz':
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => QuizScreen(category: category),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
