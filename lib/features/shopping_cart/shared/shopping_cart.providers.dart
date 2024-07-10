import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data.dart';
import '../domain.dart';
import '../presentation.dart';

class ShoppingCartProviders {
  // Data
  static final Provider<ShoppingCartDatasource> shoppingCartLocalDatasource =
      Provider((ref) => ShoppingCartLocalDatasource());

  static final Provider<ShoppingCartDatasource> shoppingCartRemoteDatasource =
      Provider((ref) => ShoppingCartRemoteDatasource());

  // Domain
  static final Provider<ShoppingCartRepository> shoppingCartRepository =
      Provider((ref) => ShoppingCartRepositoryImpl());

  // Presentation
  static final StateNotifierProvider<ShoppingCartController,
      Map<String, CartItem>> shoppingCartController = StateNotifierProvider(
    (ref) => ShoppingCartController({}),
  );

  static final Provider<double> shoppingCartTotal = Provider((ref) {
    final shoppingCart = ref.watch(shoppingCartController);
    final reducedValue = shoppingCart.values.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + element.amount * element.product.productPrice,
    );
    return double.parse(reducedValue.toStringAsFixed(2));
  });
}
