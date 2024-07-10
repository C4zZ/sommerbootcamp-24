import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/domain.dart';

class ShoppingCartController extends StateNotifier<Map<String, CartItem>> {
  ShoppingCartController(
    super.state,
  );

  Future<void> increaseProductAmount(ProductModel product, int amount) async {
    if (amount <= 0) return;
    final newMap = {...state};
    // ignore: cascade_invocations
    newMap.update(
      product.id!,
          (cardItem) =>
          CartItem(product: product, amount: cardItem.amount + amount),
      ifAbsent: () => CartItem(product: product, amount: amount),
    );
    state = newMap;
  }

  void decreaseProductAmount(ProductModel product, int amount) {
    if (amount <= 0 || !state.containsKey(product.id)) return;
    final cartItem = state[product.id];
    if (amount >= cartItem!.amount) {
      deleteProductFromCart(cartItem.product.id!);
      return;
    }
    final newMap = {...state};
    // ignore: cascade_invocations
    newMap.update(
      product.id!,
          (cardItem) =>
          CartItem(product: product, amount: cardItem.amount - amount),
    );
    state = newMap;
  }

  void setProductAmount(ProductModel product, int amount) {
    if (!state.containsKey(product.id)) return;
    if (amount <= 0) {
      deleteProductFromCart(product.id!);
    }
    final newMap = {...state};
    // ignore: cascade_invocations
    newMap.update(
      product.id!,
          (cardItem) =>
          CartItem(product: product, amount: amount),
    );
    state = newMap;
  }

  void deleteProductFromCart(String productId) {
    final newMap = {...state};
    // ignore: cascade_invocations
    newMap.remove(productId);
    state = newMap;
  }

  void clearShoppingCart() {
    state = {};
  }
}

class CartItem {
  CartItem({
    required this.product,
    required this.amount,
  });

  final ProductModel product;
  final int amount;
}
