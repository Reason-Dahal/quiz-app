import "package:flutter/material.dart";
import "package:quizapp/core/services/database_service.dart";
import "package:quizapp/data/models/question_model.dart";

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
  int correct = 0, incorrect = 0, skipped = 0;
  int? selectedAnswer;
  bool answerSubmitted = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final fetchedQuestions = await DatabaseService().getQuestionsByCategory(
      widget.category,
    );

    if (mounted) {
      setState(() {
        _questions = fetchedQuestions;
        isLoading = false;
      });
    }
  }

  void checkAnswer(int selected) {
    if (!answerSubmitted) {
      setState(() {
        selectedAnswer = selected;
        answerSubmitted = true;
      });

      if (selected == _questions[currentIndex].correctAnswer) {
        correct++;
      } else {
        incorrect++;
      }

      // Move to next question after 1.5 seconds
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          nextQuestion();
        }
      });
    }
  }

  void nextQuestion() {
    if (currentIndex < _questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        answerSubmitted = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Quiz completed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.category} Quiz')),
        body: const Center(
          child: Text('No Questions Found for this category.'),
        ),
      );
    }

    if (currentIndex >= _questions.length) {
      return Scaffold(body: Center(child: Text("Quiz Completed")));
    }

    final q = _questions[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              // child: Text('$timeLeft s', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              q.question,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ...q.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final option = entry.value;

              Color getButtonColor() {
                if (!answerSubmitted) return Colors.blue;
                if (optionIndex == q.correctAnswer) return Colors.green;
                if (optionIndex == selectedAnswer) return Colors.red;
                return Colors.blue;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(),
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () => checkAnswer(optionIndex),
                  child: Text(option),
                ),
              );
            }),
            const Spacer(),
            TextButton(
              onPressed: () {
                skipped++;
                nextQuestion();
              },
              child: const Text(
                'Skip Question',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
