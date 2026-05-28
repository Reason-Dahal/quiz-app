import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/auth_service.dart';
import 'package:quiz_app/core/services/database_service.dart';
import 'package:quiz_app/data/model/history_model.dart';
import 'package:quiz_app/data/model/question_model.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuestionModel> _questions = [];

  bool isLoading = true;

  int currentIndex = 0;
  int correct = 0;
  int incorrect = 0;
  int skipped = 0;

  Timer? timer;
  int totalTime = 0;
  int timeLeft = 15;

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
            totalTime++;
          } else {
            skipped++;
            nextQuestion();
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final fetchQuestions = await DatabaseService().getQuestionsByCategories(
      widget.category,
    );

    if (mounted) {
      setState(() {
        _questions = fetchQuestions;
        isLoading = false;
      });
      if (_questions.isNotEmpty) {
        startTimer();
      }
    }
  }

  void checkAnswer(int selected) {
    if (selected == _questions[currentIndex].correctAnswer) {
      correct++;
    } else {
      incorrect++;
    }
    nextQuestion();
  }

  void nextQuestion() {
    if (currentIndex < _questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      timer?.cancel();
      saveQuiz();
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'correct': correct,
          'incorrect': incorrect,
          'skipped': skipped,
          'totalTime': totalTime,
        },
      );
    }
  }

  Future<void> saveQuiz() async {
    final user = AuthService().currentUser;
    if (user != null) {
      final history = HistoryModel(
        category: widget.category,
        score: correct * 10,
        correct: correct,
        incorrect: incorrect,
        skipped: skipped,
        timeTaken: totalTime,
        date: DateTime.now(),
      );
      await DatabaseService().saveHistory(user.uid, history);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No question on ${widget.category}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    if (currentIndex >= _questions.length) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Quiz Completed",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final q = _questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(widget.category),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${currentIndex + 1}/${_questions.length}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Text("$timeLeft s"),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: (currentIndex + 1) / _questions.length,
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Text(
                q.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.builder(
                itemCount: q.options.length,
                itemBuilder: (context, index) {
                  final option = q.options[index];

                  final labels = ['A', 'B', 'C', 'D'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      onTap: () => checkAnswer(index),

                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          labels[index],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      title: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
