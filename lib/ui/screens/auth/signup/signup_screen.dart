import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'operation-not-allowed':
          return 'Email registration is currently disabled.';
        case 'network-request-failed':
          return 'Please check your internet connection.';
        default:
          return error.message ?? 'Something went wrong.';
      }
    }

    return 'Something went wrong. Please try again.';
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authControllerProvider);

    authState.whenOrNull(
      data: (_) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(error))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final labelStyle = theme.textTheme.titleMedium?.copyWith(fontSize: 14);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Headline
                        Text(
                          'Your story, starts Today',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            height: 1.1,
                          ),
                        ),
              
                        const SizedBox(height: 12),

                        Text(
                          'Create an account and never miss a story that matters',
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 32),

                        // Full name
                        Text('Full name', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: const InputDecoration(
                            hintText: 'Your full name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Full name is required.';
                            }

                            if (value.trim().length < 2) {
                              return 'Name must contain at least 2 characters.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Email
                        Text('Email', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'name@example.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required.';
                            }

                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(value.trim())) {
                              return 'Enter a valid email address.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password
                        Text('Password', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            hintText: 'Create a password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required.';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Confirm password
                        Text('Confirm password', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) {
                            if (!isLoading) _signup();
                          },
                          decoration: InputDecoration(
                            hintText: 'Re-enter your password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _obscureConfirmPassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password.';
                            }

                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        // Create account button
                        ElevatedButton(
                          onPressed: isLoading ? null : _signup,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Create Account'),
                        ),

                        const SizedBox(height: 20),

                        // Sign in link
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: theme.textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: colors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}