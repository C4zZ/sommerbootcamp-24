import 'package:go_router/go_router.dart';

import '../../core/domain.dart';
import '../../core/shared/goroute_model.dart';
import '../presentation.dart';

/// Settings Routes
class SettingsRoutes extends ApplicationRoutes {

  /// Root Page der Settings
  static const GoRouteModel chatRootPage =
  GoRouteModel(path: '/settings', name: 'settingsRootPage');

  @override
  List<GoRoute> get routes => throw Exception(
        'No GoRouter Routes available for this Route Configuration',
      );

  @override
  StatefulShellBranch get secureRoutes => StatefulShellBranch(
        routes: [
          GoRoute(
            path: chatRootPage.path,
            name: chatRootPage.name,
            pageBuilder: (_, __) => getPage(const SettingsPage()),
          ),
        ],
      );
}
