import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/data/model/history_model.dart';
import 'package:quiz_app/data/model/question_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    // print("response : $snapshot");
    final result = snapshot.docs.map((doc) => doc['name'] as String).toList();
    // print("data: $result");
    return result;
  }

  Future<List<QuestionModel>> getQuestionsByCategories(String category) async {
    final snapshot = await _firestore
        .collection("categories")
        .doc(category)
        .collection('questions')
        .get();

    return snapshot.docs
        .map((doc) => QuestionModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> saveHistory(String userId, HistoryModel history) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("history")
        .add(history.toMap());
  }

  Future<List<HistoryModel>> getHistory() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("history")
        .orderBy("date", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HistoryModel.fromMap(doc.data()))
        .toList();
  }
}
