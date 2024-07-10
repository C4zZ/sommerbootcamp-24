import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../shared.dart';
import '../shared/shopping_cart_routes.dart';
import 'shopping_cart.controller.dart';
import 'widgets/cart_item.dart';

/// SchoolPage
class ShoppingCartPage extends ConsumerWidget {
  /// constructor
  const ShoppingCartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(ShoppingCartProviders.shoppingCartController);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Warenkorb'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Dein Warenkorb ist leer'),
            )
          : _shoppingCartList(context, ref, cartItems, theme),
    );
  }

  Widget _shoppingCartList(
    BuildContext context,
    WidgetRef ref,
    Map<String, CartItem> cartItems,
    ThemeData theme,
  ) {
    return ListView(
      children: [
        ...cartItems.values.map(
          (e) => CartItemWidget(
            cartItem: e,
          ),
        ),
        _summaryWidget(context, ref, theme),
      ],
    );
  }

  Widget _summaryWidget(BuildContext context, WidgetRef ref, ThemeData theme) {
    final total = ref.watch(ShoppingCartProviders.shoppingCartTotal);
    final formatter = NumberFormat('#.00');
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Gesamt: ${formatter.format(total)}', style: theme.textTheme.titleMedium,),
            ElevatedButton(
              onPressed: () {
                context.goNamed(ShoppingCartRoutes.paymentPage.name);
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all<Color>(Colors.black12),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: theme.primaryColor),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  theme.primaryColor,
                ),
              ),
              child: const Text(
                'Zur Kasse',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
