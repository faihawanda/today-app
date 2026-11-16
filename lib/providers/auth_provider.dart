// Mengelola authentication state menggunakan Riverpod.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/repositories/auth_repository.dart';
import 'package:news_app/providers/dependency_provider.dart';

// Memantau authentication state Firebase secara realtime.
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges;
});

// Mengelola operasi authentication.
final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  // Login.
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signIn(email: email, password: password);
    });
  }

  // Register.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  // Logout.
  Future<void> signOut() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }
}
