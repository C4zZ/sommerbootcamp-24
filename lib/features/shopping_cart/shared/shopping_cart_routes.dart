import 'package:go_router/go_router.dart';

import '../../core/domain.dart';
import '../../core/shared/goroute_model.dart';

/// SchoolRoutes
class ShoppingCartRoutes extends ApplicationRoutes {

  /// Product Details Page
  static const GoRouteModel shoppingCartPage =
  GoRouteModel(path: 'shopping_cart', name: 'shoppingCartPage');

  /// Product Details Page
  static const GoRouteModel paymentPage =
  GoRouteModel(path: 'payment', name: 'paymentPage');

  @override
  List<GoRoute> get routes => throw Exception(
    'No GoRouter Routes available for this Route Configuration',
  );

  @override
  StatefulShellBranch get secureRoutes => throw Exception(
    'No GoRouter Routes available for this Route Configuration',
  );

}
