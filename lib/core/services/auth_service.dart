import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signUp(String email, String password) async {
    final response = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user != null) {
      await _database.collection('usersRole').doc(user.uid).set({
        'email': email,
        'role': "user",
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> getUserRole() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _database.collection('usersRole').doc(uid).get();

    return doc.data()?['role'] ?? 'user';
  }
}
