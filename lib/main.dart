import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';
import 'features/auth/shared.dart';
import 'features/chat/shared.dart';
import 'features/core/presentation/scaffold_with_navbar_tabitem.dart';
import 'features/core/shared.dart';
import 'features/product/shared.dart';
import 'features/product_selection/shared.dart';
import 'features/settings/shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MainApp()));
}

/// Main Application Widget
class MainApp extends ConsumerWidget {
  /// constructor
  MainApp({super.key});

  final GlobalKey<NavigatorState> _productNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: 'productNavigationKey');

  final GlobalKey<NavigatorState> _productSelectionNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: 'productSelectionNavigationKey');

  final GlobalKey<NavigatorState> _chatNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'chatNavigatorKey');

  final GlobalKey<NavigatorState> _settingsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'settingsNavigatorKey');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bottom Nav Bar Items
    final navBarItems = [
      ScaffoldWithNavBarTabItem(
        navigatorKey: _productNavigationKey,
        rootRoutePath: ProductRoutes.productRootPage.path,
        icon: Icon(
          Icons.toys,
          color: AppColors.blueMaterial,
        ),
        activeIcon: const Icon(
          Icons.toys,
          color: Colors.white,
        ),
        label: 'Product',
      ),
      ScaffoldWithNavBarTabItem(
        navigatorKey: _productSelectionNavigationKey,
        rootRoutePath: ProductSelectionRoutes.productSelectionRootPage.path,
        icon: Icon(
          Icons.shopping_cart,
          color: AppColors.blueMaterial,
        ),
        activeIcon: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        label: 'Selection',
      ),
      ScaffoldWithNavBarTabItem(
        navigatorKey: _chatNavigatorKey,
        rootRoutePath: ChatRoutes.chatRootPage.path,
        icon: Icon(
          Icons.support_agent,
          color: AppColors.blueMaterial,
        ),
        activeIcon: const Icon(
          Icons.support_agent,
          color: Colors.white,
        ),
        label: 'Settings',
      ),
      ScaffoldWithNavBarTabItem(
        navigatorKey: _settingsNavigatorKey,
        rootRoutePath: SettingsRoutes.chatRootPage.path,
        icon: Icon(
          Icons.settings,
          color: AppColors.blueMaterial,
        ),
        activeIcon: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        label: 'Chat',
      ),
    ];

    final authRedirectService = ref.read(AuthProviders.authRedirectService);

    final appRouteService = ref.read(CoreProviders.appRouterService)
      ..addRoutes(
        routes: [
          GoRoute(path: '/', redirect: (_, __) => ProductRoutes.productRootPage.path),
        ],
      )
      ..addRouteConfigurations(
        routeConfigurations: [
          ref.read(ProductProviders.routes),
          ref.read(ProductSelectionProviders.routes),
          ref.read(ChatProviders.routes),
          ref.read(SettingsProviders.routes),
        ],
        addToShell: true,
      )
      ..addRouteConfiguration(
        routeConfiguration: ref.read(AuthProviders.routes),
      )
      ..setRefreshListenable(ref.watch(AuthProviders.authStateNotifier))
      ..setRedirect(authRedirectService.redirect);

    return MaterialApp.router(
      title: "Sommerbootcamp '24",
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      routerConfig: appRouteService.bottomTabBarShellRouter(navBarItems),
    );
  }
}
