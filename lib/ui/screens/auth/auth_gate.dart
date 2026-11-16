import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/ui/screens/auth/login/login_screen.dart';
import 'package:news_app/ui/screens/main_shell/main_shell_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 42),
                const SizedBox(height: 16),
                const Text(
                  'Unable to check your account.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(authStateProvider);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (user) {
        if (user != null) {
          return const MainShellScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
