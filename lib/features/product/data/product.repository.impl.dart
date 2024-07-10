import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../auth/domain/auth.repository.dart';
import '../../core/shared.dart';
import '../domain.dart';

/// Implementation for [ProductRepository]
class ProductRepositoryImpl implements ProductRepository {
  /// constructor
  ProductRepositoryImpl({
    required this.appwriteClient,
    required this.authRepository,
  });

  /// Appwrite Client
  final AppwriteClient appwriteClient;

  /// Auth Repository
  final AuthRepository authRepository;
  final Uuid _uuid = const Uuid();

  @override
  Future<String> uploadProductImage({
    required String postId,
    required Uint8List image,
  }) async {
    final file = await appwriteClient.storage.createFile(
      bucketId: appwriteClient.imagesBucketId,
      fileId: _uuid.v1(),
      file: InputFile.fromBytes(
        bytes: image,
        filename: postId,
      ),
    );
    return file.$id;
  }

  @override
  Future<void> createProduct({
    required String productName,
    required String productDescription,
    required String accessoriesDescription,
    required double productPrice,
    List<Uint8List>? productImages,
    List<Uint8List>? accessoriesImages,
  }) async {
    final productId = _uuid.v1();
    final userId = authRepository.currentUser?.$id;
    String? productImageId;
    String? accessoryImageId;

    if (null != productImages && productImages.isNotEmpty) {
      // Due to Appwrite's rate limits only uploading first image in array to
      // Backend (see https://appwrite.io/docs/advanced/platform/rate-limits)
      productImageId = await uploadProductImage(
        postId: productId,
        image: productImages.first,
      );
    }

    if (null != accessoriesImages && accessoriesImages.isNotEmpty) {
      // Due to Appwrite's rate limits only uploading first image in array to
      // Backend (see https://appwrite.io/docs/advanced/platform/rate-limits)
      accessoryImageId = await uploadProductImage(
        postId: productId,
        image: accessoriesImages.first,
      );
    }

    // TODO(team): lege eine Model Klasse an
    final data = <String, dynamic>{
      'user_id': userId,
      'productName': productName,
      'productDescription': productDescription,
      'accessoriesDescription': accessoriesDescription,
      'productPrice': productPrice,
      // Only adding first product and accessory image id to product because
      // only those images get uploaded to Backend
      'productImageIds': productImageId != null ? [productImageId] : [''],
      'accessoriesImageIds':
          accessoryImageId != null ? [accessoryImageId] : [''],
    };

    try {
      await appwriteClient.databases.createDocument(
          databaseId: appwriteClient.databaseId,
          collectionId: appwriteClient.productCollectionId,
          documentId: productId,
          data: data,
        permissions: [
          Permission.read(Role.users()),
          Permission.update(Role.user(userId!)),
          Permission.delete(Role.user(userId)),
        ],
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProducts({
    bool shouldContainOwnProducts = false,
  }) async {
    final products = await appwriteClient.databases.listDocuments(
      databaseId: appwriteClient.databaseId,
      collectionId: appwriteClient.productCollectionId,
      queries: shouldContainOwnProducts
          ? null
          : [
              Query.notEqual(
                'user_id',
                authRepository.currentUser?.$id,
              ),
            ],
    );

    final productModels = products.convertTo(
      (p0) {
        var product = ProductModel.fromJson(p0 as Map<String, dynamic>);
        return product.copyWith(
          productImageIds: product.productImageIds
              .where((id) => id != null && id != '')
              .toList(),
          accessoriesImageIds: product.accessoriesImageIds
              .where((id) => id != null && id != '')
              .toList(),
        );
      },
    ).reversed.toList();

    return productModels;
  }

  @override
  Future<Uint8List> getImage({
    required String bucketId,
    required String fileId,
    int? width,
    int? height,
    int? quality,
  }) async {
    final image = await appwriteClient.storage.getFilePreview(
      bucketId: bucketId,
      fileId: fileId,
      width: width,
      height: height,
      quality: quality,
    );
    return image;
  }

  @override
  Future<ProductModel> getProduct({required String productId}) async {
    final product = await appwriteClient.databases.getDocument(
      databaseId: appwriteClient.databaseId,
      collectionId: appwriteClient.productCollectionId,
      documentId: productId,
    );

    final productModel = product.convertTo(
          (p0) {
        var product = ProductModel.fromJson(p0 as Map<String, dynamic>);
        return product.copyWith(
          productImageIds: product.productImageIds
              .where((id) => id != null && id != '')
              .toList(),
          accessoriesImageIds: product.accessoriesImageIds
              .where((id) => id != null && id != '')
              .toList(),
        );
      },
    );

    return productModel;
  }
}
