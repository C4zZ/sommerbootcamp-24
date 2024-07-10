import 'package:go_router/go_router.dart';

import '../../core/domain.dart';
import '../../core/shared/goroute_model.dart';
import '../../product/domain.dart' show ProductModel;
import '../../shopping_cart/presentation/payment.page.dart';
import '../../shopping_cart/shared/shopping_cart_routes.dart';
import '../presentation.dart'
    show ProductDetailsPage, ProductSelectionPage, ShoppingCartPage;

/// SchoolRoutes
class ProductSelectionRoutes extends ApplicationRoutes {
  /// ProductSelection Root Page
  static const GoRouteModel productSelectionRootPage =
      GoRouteModel(path: '/product_selection', name: 'productSelectionRootPage');

  /// Product Details Page
  static const GoRouteModel productDetailsPage =
      GoRouteModel(path: 'product_details', name: 'productDetailsPage');

  @override
  List<GoRoute> get routes => throw Exception(
        'No GoRouter Routes available for this Route Configuration',
      );

  @override
  StatefulShellBranch get secureRoutes => StatefulShellBranch(
        routes: [
          GoRoute(
            path: productSelectionRootPage.path,
            name: productSelectionRootPage.name,
            pageBuilder: (_, state) => getPage(const ProductSelectionPage()),
            routes: [
              GoRoute(
                path: productDetailsPage.path,
                name: productDetailsPage.name,
                pageBuilder: (_, state) {
                  final product = state.extra! as ProductModel;
                  return getPage(
                    ProductDetailsPage(
                      product: product,
                    ),
                  );
                },
              ),
              GoRoute(
                path: ShoppingCartRoutes.shoppingCartPage.path,
                name: ShoppingCartRoutes.shoppingCartPage.name,
                pageBuilder: (_, state) => getPage(const ShoppingCartPage()),
                routes: [
                  GoRoute(
                    path: ShoppingCartRoutes.paymentPage.path,
                    name: ShoppingCartRoutes.paymentPage.name,
                    pageBuilder: (_, state) => getPage(const PaymentPage()),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
