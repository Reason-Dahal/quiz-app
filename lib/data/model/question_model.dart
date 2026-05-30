class QuestionModel {
  final String? id;
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuestionModel({
    this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> map, String docId) {
    return QuestionModel(
      id: docId,
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}
