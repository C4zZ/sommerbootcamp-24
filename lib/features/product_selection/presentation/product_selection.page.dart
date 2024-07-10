import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../product/domain/models/product_model.dart';
import '../../product/shared/product.providers.dart';
import '../../shopping_cart/shared/shopping_cart_routes.dart';
import 'widgets/product_card.dart';

/// SchoolPage
class ProductSelectionPage extends ConsumerWidget {
  /// constructor
  const ProductSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(ProductProviders.getAllProducts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikelauswahl'),
        actions: [
          IconButton(
            onPressed: () async {
              context.goNamed(ShoppingCartRoutes.shoppingCartPage.name);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: allProducts.when(
        data: (data) {
          return data.isNotEmpty
              ? _productList(data, ref)
              : const Center(
                  child: Text('Keine Produkte vorhanden'),
                );
        },
        error: (_, __) => const Center(
          child: Text('Ups! Da ist was schief gelaufen...'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  Widget _productList(List<ProductModel> products, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ProductProviders.getAllProducts);
      },
      child: ListView.separated(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(productModel: products[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}
