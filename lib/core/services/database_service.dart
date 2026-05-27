import "package:cloud_firestore/cloud_firestore.dart";
import "package:quizapp/data/models/history_model.dart";
import "package:quizapp/data/models/question_model.dart";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    final result = snapshot.docs.map((doc) => doc['name'] as String).toList();
    return result;
  }

  Future<List<QuestionModel>> getQuestionsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('categories')
        .doc(category)
        .collection('questions')
        .get();

    return snapshot.docs
        .map((doc) => QuestionModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> saveQuizResult(String userId, HistoryModel history) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .add(history.toMap());
  }

  
}
