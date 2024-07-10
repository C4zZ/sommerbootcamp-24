import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/shared.dart';
import '../../core/domain/models/application_routes.dart';
import '../../core/shared.dart';
import '../data.dart';
import '../domain.dart';
import '../shared.dart';

/// Product Feature Providers
class ProductProviders {
  // Data

  /// Product Remote Datasource
  static final Provider<ProductDatasource> productRemoteDatasource =
      Provider((ref) => ProductRemoteDatasource());

  // Domain
  /// Product Repository
  static final Provider<ProductRepository> productRepository = Provider(
    (ref) => ProductRepositoryImpl(
      appwriteClient: ref.read(CoreProviders.appwrite),
      authRepository: ref.read(AuthProviders.authRepository),
    ),
  );

  // Presentation

  /// get all products
  static final FutureProvider<List<ProductModel>> getAllProducts =
      FutureProvider(
    (ref) async => ref.watch(productRepository).getProducts(
          shouldContainOwnProducts: true,
        ),
  );

  // shared
  /// Product Feature Routes
  static final Provider<ApplicationRoutes> routes = Provider<ProductRoutes>(
    (ref) => ProductRoutes(),
  );
}
