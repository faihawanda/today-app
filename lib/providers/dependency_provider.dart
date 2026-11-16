//depedency injection = sebuah metode unutuk menyuntikan

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/repositories/auth_repository.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/data/services/bookmark_storage.dart';
import 'package:news_app/data/services/firebase_auth_service.dart';
import 'package:news_app/data/services/news_api_service.dart';

final newsApiServiceProvider = Provider<NewsApiService>(
  (ref) => NewsApiService(),
);

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(ref.watch(newsApiServiceProvider)),
);

final bookmarkStorageProvider = Provider<BookmarkStorage>(
  (ref) => BookmarkStorage(),
);

// nantinya auth_provider.dart cukup memanggil authRepositoryProvider, tanpa perlu membuat Firebase Service secara manual.

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthServiceProvider)),
);
