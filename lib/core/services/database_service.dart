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

    final response = snapshot.docs
        .map((doc) => QuestionModel.fromJson(doc.data()))
        .toList();

    return response;
  }

  Future<void> saveQuizResult(String userId, HistoryModel history) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .add(history.toMap());
  }

  Stream<List<HistoryModel>> getUserHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HistoryModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteUserHistory(String userId) async {
    final historyCollection = _firestore
        .collection('users')
        .doc(userId)
        .collection('history');
    final snapshots = await historyCollection.get();

    WriteBatch batch = _firestore.batch();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
