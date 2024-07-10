import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain.dart' show ApplicationRoutes;
import '../../core/shared/goroute_model.dart';
import '../presentation/login.page.dart';

/// Routes for the auth Feature
class AuthRoutes extends ApplicationRoutes {

  /// Login Root Page
  static const GoRouteModel loginRoute =
  GoRouteModel(path: '/login', name: 'loginRootPage');

  @override
  List<GoRoute> get routes => [
    GoRoute(
      path: loginRoute.path,
      name: loginRoute.name,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition<LoginPage>(
          context: context,
          state: state,
          child: const LoginPage(),
        );
      },
    ),
  ];

  @override
  StatefulShellBranch get secureRoutes => throw UnimplementedError(
    'No GoRouter Routes available for this Route Configuration',
  );
}
