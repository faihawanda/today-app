
import 'package:intl/intl.dart';

/// Helper for formatting dates in English.
class DateFormatter {
  DateFormatter._();

  static const String _locale = 'en_US';

  /// Examples: "Just now", "5 minutes ago", "3 hours ago".
  static String relative(DateTime? date) {
    if (date == null) return '';

    final local = date.toLocal();
    final diff = DateTime.now().difference(local);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return DateFormat('MMM d, yyyy', _locale).format(local);
  }

  /// Example: "Wednesday, October 7, 2026 • 22:40".
  static String full(DateTime? date) {
    if (date == null) return '';

    return DateFormat(
      'EEEE, MMMM d, yyyy • HH:mm',
      _locale,
    ).format(date.toLocal());
  }

  /// Example: "Saturday, November 14".
  static String today() =>
      DateFormat('EEEE, MMMM d', _locale).format(DateTime.now());
}
