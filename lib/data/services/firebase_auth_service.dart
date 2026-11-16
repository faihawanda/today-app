// bertugas untuk komunikasi langsung dengan Firebase Authentication

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Mengambil status autentikasi pengguna secara realtime.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Mengambil pengguna yang sedang login.
  User? get currentUser => _firebaseAuth.currentUser;

  // Register pengguna baru.
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name.trim());

    return credential;
  }

  // Login pengguna.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Logout pengguna.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
