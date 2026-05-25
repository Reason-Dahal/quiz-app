class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? "",
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correct_answer'] ?? 0,
    );
  }
}
