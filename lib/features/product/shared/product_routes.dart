
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain/models/application_routes.dart';
import '../../core/shared/goroute_model.dart';
import '../presentation.dart';

/// Feed Feature routes
class ProductRoutes extends ApplicationRoutes {
  /// Feed Page
  static const GoRouteModel productRootPage =
      GoRouteModel(path: '/product', name: 'ProductRootPage');

  @override
  StatefulShellBranch get secureRoutes => StatefulShellBranch(
        routes: [
          GoRoute(
            path: productRootPage.path,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                buildPageWithDefaultTransition<ProductPage>(
              context: context,
              state: state,
              child: const ProductPage(),
            ),
          ),
        ],
      );

  @override
  List<GoRoute> get routes => throw Exception(
        'No GoRouter Routes available for this Route Configuration',
      );
}
