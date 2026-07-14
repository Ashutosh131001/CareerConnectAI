import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> registerWithEmail(String email, String password);
  Future<Map<String, dynamic>?> getUserFirestoreData(String uid);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<Map<String, dynamic>?> getUserFirestoreData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}