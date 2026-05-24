import 'package:cloud_firestore/cloud_firestore.dart';
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
}
