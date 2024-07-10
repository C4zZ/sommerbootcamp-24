import 'package:flutter/material.dart';

import '../shopping_cart.controller.dart';
import 'cart_image.dart';
import 'cart_quantity_input_field.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    required this.cartItem,
    super.key,
  });

  final CartItem cartItem;

  @override
  State<StatefulWidget> createState() => CartItemState();
}

class CartItemState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: CartImage(
                imageId: widget.cartItem.product.productImageIds.firstOrNull,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.cartItem.product.productName,
                style: theme.titleMedium,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: CartQuantityInputField(cartItem: widget.cartItem),
          ),
        ],
      ),
    );
  }
}
