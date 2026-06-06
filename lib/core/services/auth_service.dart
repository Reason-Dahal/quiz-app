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

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user logged in');
      }

      if (currentPassword.isEmpty || newPassword.isEmpty) {
        throw Exception('Password fields cannot be empty');
      }

      if (currentPassword == newPassword) {
        throw Exception('New password must be different from current password');
      }

      if (newPassword.length < 6) {
        throw Exception('New password must be at least 6 characters long');
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error changing password: ${e.toString()}');
    }
  }

  /// Handle Firebase Auth exceptions with user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Current password is incorrect';
      case 'user-not-found':
        return 'User not found';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Password change operation is not allowed';
      case 'weak-password':
        return 'New password is too weak. Please use a stronger password';
      case 'requires-recent-login':
        return 'Please log in again before changing your password';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}
