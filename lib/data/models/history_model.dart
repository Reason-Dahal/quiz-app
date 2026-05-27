import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String category;
  final int score;
  final int correct;
  final int incorrect;
  final int skipped;
  final int timeTaken;
  final DateTime date;

  HistoryModel({
    required this.category,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.skipped,
    required this.timeTaken,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'score': score,
      'correct': correct,
      'incorrect': incorrect,
      'skipped': skipped,
      'timeTaken': timeTaken,
      'date': Timestamp.fromDate(date),
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      category: map['category'] ?? '',
      score: map['score'] ?? 0,
      correct: map['correct'] ?? 0,
      incorrect: map['incorrect'] ?? 0,
      skipped: map['skipped'] ?? 0,
      timeTaken: map['timeTaken'] ?? 0,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
