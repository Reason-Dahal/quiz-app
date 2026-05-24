class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? "",
      correctAnswer: map['correctAnswer'] ?? "",
      options: List<String>.from(map['options'] ?? []),
    );
  }
}
