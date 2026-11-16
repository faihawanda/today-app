import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '-');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not signed in');
      }

      await user.updateDisplayName(name);
      await user.reload();

      ref.invalidate(authStateProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to update profile')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Thin border so white fields stay visible on a white screen.
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
    );

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),

          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(26),
              ),
              alignment: Alignment.center,
              child: Text(
                _nameController.text.trim().isEmpty
                    ? 'U'
                    : _nameController.text.trim()[0].toUpperCase(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: scheme.onPrimary,
                  fontSize: 34,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'PERSONAL INFORMATION',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: scheme.primary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Full Name',
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              fillColor: scheme.surface,
              enabledBorder: fieldBorder,
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 22),

          Text(
            'Email Address',
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),

          TextField(
            readOnly: true,
            controller: _emailController,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
            decoration: InputDecoration(
              fillColor: scheme.surfaceContainer,
              enabledBorder: fieldBorder,
              focusedBorder: fieldBorder,
              prefixIcon: const Icon(Icons.email_outlined),
              suffixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
            ),
          ),

          const SizedBox(height: 32),

          // Uses elevatedButtonTheme from AppTheme (black, full width).
          ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
  }