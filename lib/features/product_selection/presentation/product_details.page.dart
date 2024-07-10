import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/domain/models/product_model.dart';
import 'widgets/add_to_cart_action.dart';
import 'widgets/image_gallery.dart';

/// SchoolPage
class ProductDetailsPage extends ConsumerWidget {
  /// constructor
  const ProductDetailsPage({
    required this.product,
    super.key,
  });

  final ProductModel product;

  final double _verticalPaddingLarge = 16;
  final double _verticalPaddingSmall = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            // TODO(team): Gestalte die Detailseite des Produkts. Denke dir ein
            //  Design für die Seite aus und setze es um
            // TODO(team): Zeige den Preis des Produktes für jedes Produkt in
            //  der Detailseite an
            Text('TODO')
          ],
        ),
      ),
    );
  }
}
