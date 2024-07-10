import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain.dart';
import '../shared.dart';

/// Core Riverpod Providers
class CoreProviders {
  // Data

  // Domain
  /// Provides the default implementation of the App Routing Service
  static Provider<ApplicationRouterService> get appRouterService =>
      Provider((ref) => ApplicationRouterServiceImpl());

  // Presentation

  // Shared
  /// Project specific Appwrite Client
  static final Provider<AppwriteClient> appwrite = Provider(
    (ref) => AppwriteClient(),
  );
}
