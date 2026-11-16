// Menjadi perantara antara service dan aplikasi.
// Mengatur operasi authentication agar tidak bergantung langsung pada UI.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/data/services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository(this._authService);

  // Memantau perubahan status autentikasi.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Mengambil pengguna yang sedang login.
  User? get currentUser => _authService.currentUser;

  // Register akun baru.
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authService.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  // Login akun.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(email: email, password: password);
  }

  // Logout akun.
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
