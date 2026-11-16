import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/services/theme_storage.dart';
import 'package:news_app/providers/theme_provider.dart';

import 'app.dart';

Future<void> main() async {
  // Memastikan Flutter siap sebelum proses inisialisasi.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load environment variables.
  await dotenv.load(isOptional: true);

  // Initialize date formatting Indonesia.
  await initializeDateFormatting('en_US');

  // Load user theme preference.
  final initialTheme = await ThemeStorage().load();

  runApp(
    ProviderScope(
      // Mematikan auto retry bawaan Riverpod.
      retry: (retryCount, error) => null,
      overrides: [initialThemeProvider.overrideWithValue(initialTheme)],
      child: NewsApp(),
    ),
  );
}
