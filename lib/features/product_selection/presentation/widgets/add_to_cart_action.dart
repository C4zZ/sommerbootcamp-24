import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/domain/models/product_model.dart';
import '../../../shopping_cart/shared/shopping_cart.providers.dart';
import 'quantity_input_field.dart';

class AddToCartAction extends ConsumerStatefulWidget {
  const AddToCartAction({
    required this.product,
    super.key,
  });

  final ProductModel product;

  @override
  ConsumerState<AddToCartAction> createState() => _AddToCartActionState();
}

class _AddToCartActionState extends ConsumerState<AddToCartAction> {
  bool isOpen = false;

  int amount = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: SizedBox(
        height: 35,
        child: Row(
          children: [
            Expanded(
              child: QuantityInputField(
                onQuantityChanged: (value) {
                  final str = value.toString();
                  amount = int.parse(str);
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _addToCart,
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
                  'In den Warenkorb',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    ref
        .read(ShoppingCartProviders.shoppingCartController.notifier)
        .increaseProductAmount(widget.product, amount);
  }
}
