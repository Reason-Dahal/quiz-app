import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/database_service.dart';
import 'package:quiz_app/data/model/question_model.dart';

class QuestionScreen extends StatefulWidget {
  final String category;

  const QuestionScreen({super.key, required this.category});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final DatabaseService _db = DatabaseService();

  List<QuestionModel> questions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    setState(() {
      isLoading = true;
    });

    questions = await _db.getQuestionsByCategories(widget.category);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteQuestion(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Question"),
          content: const Text("Are you sure you want to delete this question?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await _db.deleteQuestion(widget.category, id);

    loadQuestions();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Question deleted")));
    }
  }

  Future<void> showQuestionDialog({QuestionModel? question}) async {
    final questionController = TextEditingController(
      text: question?.question ?? '',
    );

    final option1Controller = TextEditingController(
      text: question?.options[0] ?? '',
    );

    final option2Controller = TextEditingController(
      text: question?.options[1] ?? '',
    );

    final option3Controller = TextEditingController(
      text: question?.options[2] ?? '',
    );

    final option4Controller = TextEditingController(
      text: question?.options[3] ?? '',
    );

    int correctAnswer = question?.correctAnswer ?? 0;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(question == null ? "Add Question" : "Edit Question"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(labelText: "Question"),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: option1Controller,
                      decoration: const InputDecoration(labelText: "Option 1"),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: option2Controller,
                      decoration: const InputDecoration(labelText: "Option 2"),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: option3Controller,
                      decoration: const InputDecoration(labelText: "Option 3"),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: option4Controller,
                      decoration: const InputDecoration(labelText: "Option 4"),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: correctAnswer,
                      decoration: const InputDecoration(
                        labelText: "Correct Answer",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("Option 1")),
                        DropdownMenuItem(value: 1, child: Text("Option 2")),
                        DropdownMenuItem(value: 2, child: Text("Option 3")),
                        DropdownMenuItem(value: 3, child: Text("Option 4")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          correctAnswer = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (questionController.text.trim().isEmpty) {
                      return;
                    }

                    final newQuestion = QuestionModel(
                      id: question?.id,
                      question: questionController.text.trim(),
                      options: [
                        option1Controller.text.trim(),
                        option2Controller.text.trim(),
                        option3Controller.text.trim(),
                        option4Controller.text.trim(),
                      ],
                      correctAnswer: correctAnswer,
                    );

                    if (question == null) {
                      await _db.addQuestion(widget.category, newQuestion);
                    } else {
                      await _db.updateQuestion(widget.category, newQuestion);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    loadQuestions();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            question == null
                                ? "Question Added"
                                : "Question Updated",
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(question == null ? "Add" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildQuestionCard(QuestionModel question) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: ExpansionTile(
        leading: const CircleAvatar(child: Icon(Icons.quiz)),

        title: Text(
          question.question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        childrenPadding: const EdgeInsets.all(16),

        children: [
          for (int i = 0; i < question.options.length; i++)
            ListTile(
              dense: true,
              leading: Icon(
                i == question.correctAnswer
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: i == question.correctAnswer ? Colors.green : null,
              ),
              title: Text(question.options[i]),
            ),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Edit",
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  showQuestionDialog(question: question);
                },
              ),

              IconButton(
                tooltip: "Delete",
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteQuestion(question.id!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Questions")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showQuestionDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text("Question"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
          ? const Center(child: Text("No Questions Found"))
          : RefreshIndicator(
              onRefresh: loadQuestions,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return buildQuestionCard(questions[index]);
                },
              ),
            ),
    );
  }
}
