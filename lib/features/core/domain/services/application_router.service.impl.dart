import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../domain.dart';
import '../../presentation/scaffold_with_navbar_tabitem.dart';
import '../../presentation/widgets/shell_scaffold.dart';

/// [ApplicationRouterService] implementation
class ApplicationRouterServiceImpl implements ApplicationRouterService {
  final List<GoRoute> _routes = [];
  final List<StatefulShellBranch> _branches = [];

  Listenable? _refreshListenable;
  FutureOr<String?> Function(BuildContext, GoRouterState)? _redirect;

  /// Get GoRouter instance
  @override
  GoRouter get router => GoRouter(
        routes: _routes,
        refreshListenable: _refreshListenable,
        redirect: _redirect,
      );

  /// Add additional Routes to GoRouter
  @override
  void addRoutes({required List<GoRoute> routes}) {
    _routes.addAll(routes);
  }

  /// Add route configuration from [ApplicationRoutes]
  @override
  void addRouteConfiguration({
    required ApplicationRoutes routeConfiguration,
    bool addToShell = false,
  }) {
    if (addToShell) {
      _branches.add(routeConfiguration.secureRoutes);
    } else {
      addRoutes(routes: routeConfiguration.routes);
    }
  }

  /// Add a List of Route Configurations
  @override
  void addRouteConfigurations({
    required List<ApplicationRoutes> routeConfigurations,
    bool addToShell = false,
  }) {
    for (final routeConfig in routeConfigurations) {
      addRouteConfiguration(
        routeConfiguration: routeConfig,
        addToShell: addToShell,
      );
    }
  }

  /// set router refresh listenable
  // ignore: use_setters_to_change_properties
  @override
  void setRefreshListenable(Listenable? listenable) =>
      _refreshListenable = listenable;

  /// set redirect function callback
  // ignore: use_setters_to_change_properties
  @override
  void setRedirect(
    FutureOr<String?> Function(BuildContext, GoRouterState)? redirect,
  ) =>
      _redirect = redirect;

  @override
  GoRouter bottomTabBarShellRouter(
    List<ScaffoldWithNavBarTabItem> tabs,
  ) {
    return GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, __, StatefulNavigationShell shell) {
            return ShellScaffold(
              shell: shell,
              tabs: tabs,
              showNavBarOnLandscape: false,
            );
          },
          branches: _branches,
        ),
        ..._routes,
      ],
      refreshListenable: _refreshListenable,
      redirect: _redirect,
    );
  }
}
