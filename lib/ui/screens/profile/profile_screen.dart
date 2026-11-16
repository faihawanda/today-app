import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/ui/widgets/error_state.dart';
import 'package:news_app/ui/widgets/theme_toggle_button.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = ref.watch(authStateProvider);

    final savedCount = ref.watch(bookmarksProvider).maybeWhen(
          data: (items) => items.length.toString(),
          orElse: () => '-',
        );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ErrorState(
            error: error,
            onRetry: () => ref.invalidate(authStateProvider),
          ),
          data: (user) {
            // Get user data from Firebase
            final name = user?.displayName?.trim().isNotEmpty == true
                ? user!.displayName!.trim()
                : 'Today User';

            final email = user?.email ?? '-';
            final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

            final created = user?.metadata.creationTime;
            final memberSince = created == null
                ? '-'
                : '${_months[created.month - 1]} ${created.year}';

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                // Title + theme toggle
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My Profile',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                      ),
                      const ThemeToggleButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Profile header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initial,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: scheme.onPrimary,
                            fontSize: 36,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(email, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: scheme.outline.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _stat(context, savedCount, 'Saved'),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: scheme.outline.withValues(alpha: 0.4),
                          ),
                          Expanded(
                            child: _stat(context, memberSince, 'Member since'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _groupCard(
                  context,
                  children: [
                    _row(
                      context,
                      icon: Icons.person_rounded,
                      title: 'Edit Profile',
                      subtitle: 'Manage your personal information',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _row(
                      context,
                      icon: Icons.mail_rounded,
                      title: 'Email',
                      subtitle: email,
                      trailing: user?.emailVerified == true
                          ? _badge(context, 'Verified')
                          : null,
                    ),
                    _row(
                      context,
                      icon: Icons.calendar_today_rounded,
                      title: 'Member since',
                      subtitle: memberSince,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Sign out button
                SizedBox(
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () => _showSignOutDialog(context, ref),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      backgroundColor: scheme.surface,
                      side: BorderSide(
                        color: scheme.primary.withValues(alpha: 0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Center(
                  child: Text(
                    'TODAY · V1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _badge(BuildContext context, String text) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  /// One white card that groups several rows, separated by thin dividers.
  Widget _groupCard(BuildContext context, {required List<Widget> children}) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(
                height: 1,
                indent: 74,
                endIndent: 16,
                color: scheme.outline.withValues(alpha: 0.3),
              ),
          ],
        ],
      ),
    );
  }

  /// A row inside [_groupCard]. Tappable when [onTap] is set,
  /// otherwise it is an info row.
  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: theme.textTheme.bodySmall?.color,
              ),
          ],
        ),
      ),
    );
  }

    Future<void> _showSignOutDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final scheme = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: scheme.surface, // putih di light mode
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sign Out?'),
        content: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Sign Out', style: TextStyle(color: scheme.primary)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(authControllerProvider.notifier).signOut();
  }
}