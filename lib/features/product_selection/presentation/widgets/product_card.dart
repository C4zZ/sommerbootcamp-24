import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../product/domain/models/product_model.dart';
import '../../shared.dart';
import 'image_gallery.dart';
import 'like_action.dart';

/// Quickview of a product
class ProductCard extends ConsumerWidget {
  /// constructor
  const ProductCard({required this.productModel, super.key});

  /// model of product to display
  final ProductModel productModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        context.goNamed(
          ProductSelectionRoutes.productDetailsPage.name,
          extra: productModel,
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ImageGallery(
                  imageIds: productModel.productImageIds,
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: LikeAction(),
                ),
              ],
            ),
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO(team): Zeige den Preis des Produktes für jedes Produkt
                  //  in der Produktliste an
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productModel.productName,
                        style: theme.titleMedium,
                      ),
                      Text(
                        '${productModel.productPrice} €',
                        style: theme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    productModel.productDescription,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
