import 'dart:typed_data';

import '../domain.dart' show ProductModel;

/// FeedRepository
abstract class ProductRepository {
  /// Create new Post
  Future<void> createProduct({
    required String productName,
    required String productDescription,
    required String accessoriesDescription,
    required double productPrice,
    List<Uint8List>? productImages,
    List<Uint8List>? accessoriesImages,
  });

  /// Upload Image to Post Storage
  Future<String> uploadProductImage({
    required String postId,
    required Uint8List image,
  });

  /// Get all Posts
  Future<List<ProductModel>> getProducts({
    bool shouldContainOwnProducts = false,
  });

  /// Get specific Posts
  Future<ProductModel> getProduct({
    required String productId,
  });

  /// Get image from storage
  Future<Uint8List> getImage({
    required String bucketId,
    required String fileId,
  });
}
