import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/models/application_routes.dart';
import '../data.dart';
import '../domain.dart';
import '../shared.dart';

/// Setting Feature Providers
class SettingsProviders {
  // Data

  /// Remote Datasoure
  static final Provider<SettingsDatasource> settingsRemoteDatasource =
      Provider((ref) => SettingsRemoteDatasource());

  // Domain
  /// Settings Repository
  static final Provider<SettingsRepository> settingsRepository =
      Provider((ref) => SettingsRepositoryImpl());

  // Presentation

  // shared
  /// Settings Feature Routes
  static final Provider<ApplicationRoutes> routes = Provider<SettingsRoutes>(
    (ref) => SettingsRoutes(),
  );
}
