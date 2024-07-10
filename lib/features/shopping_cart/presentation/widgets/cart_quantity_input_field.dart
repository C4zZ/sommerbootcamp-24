import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shopping_cart.providers.dart';
import '../shopping_cart.controller.dart';

class CartQuantityInputField extends ConsumerStatefulWidget {
  const CartQuantityInputField({
    required this.cartItem,
    super.key,
  });

  final CartItem cartItem;

  @override
  ConsumerState<CartQuantityInputField> createState() =>
      _CartQuantityInputFieldState();
}

class _CartQuantityInputFieldState
    extends ConsumerState<CartQuantityInputField> {
  late int cartItemAmount;

  @override
  void initState() {
    cartItemAmount = widget.cartItem.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _amountWidget(theme),
        const SizedBox(width: 10,),
        Column(
          children: [
            _addWidget(theme),
            _subtractWidget(theme),
          ],
        )
      ],
    );
  }

  Widget _amountWidget(ThemeData theme) {
    return Text(
      _formattedCartItemAmount(),
      style: theme.textTheme.titleMedium,
    );
  }

  Widget _addWidget(ThemeData theme) {
    return IconButton(
      onPressed: _add,
      icon: Icon(
        Icons.add,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _subtractWidget(ThemeData theme) {
    return IconButton(
      onPressed: _subtract,
      icon: Icon(
        Icons.remove,
        color: theme.primaryColor,
      ),
    );
  }

  void _add() {
    if (cartItemAmount == 99) return;
    setState(() {
      cartItemAmount += 1;
    });
    _setCartItemAmount();
  }

  void _subtract() {
    if (cartItemAmount == 0) return;
    setState(() {
      cartItemAmount -= 1;
    });
    _setCartItemAmount();
  }

  void _setCartItemAmount() {
    ref
        .read(
          ShoppingCartProviders.shoppingCartController.notifier,
        )
        .setProductAmount(
          widget.cartItem.product,
          cartItemAmount,
        );
  }

  String _formattedCartItemAmount() {
    if (cartItemAmount <= 9) {
      return '0$cartItemAmount';
    }
    return '$cartItemAmount';
  }
}
