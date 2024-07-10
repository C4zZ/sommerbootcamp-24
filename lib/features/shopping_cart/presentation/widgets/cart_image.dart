import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/core.providers.dart';
import '../../../product/shared/product.providers.dart';

class CartImage extends ConsumerStatefulWidget {
  const CartImage({
    required this.imageId,
    super.key,
  });

  final String? imageId;

  @override
  ConsumerState<CartImage> createState() => _CartImageState();
}

class _CartImageState extends ConsumerState<CartImage> {
  @override
  Widget build(BuildContext context) {
    final appwriteClient = ref.read(CoreProviders.appwrite);
    final productRepository = ref.read(ProductProviders.productRepository);

    return widget.imageId != null ? FutureBuilder(
      future: productRepository.getImage(
        bucketId: appwriteClient.imagesBucketId,
        fileId: widget.imageId!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator.adaptive();
        }
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 16 / 11,
            child: Image.memory(
              snapshot.requireData,
              fit: BoxFit.cover,
            ),
          );
        }
        return const SizedBox();
      },
    ) : const SizedBox();
  }
}
