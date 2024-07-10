import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/domain/models/application_routes.dart';
import '../data.dart';
import '../domain.dart';
import '../shared.dart';

/// School Feature Provider
class ProductSelectionProviders {
  // Data

  /// Remote Datasource
  static final Provider<ProductSelectionDatasource>
      productSelectionRemoteDatasource =
      Provider((ref) => ProductSelectionRemoteDatasource());

  // Domain
  /// School Repositoy
  static final Provider<ProductSelectionRepository> schoolRepository =
      Provider((ref) => ProductSelectionRepositoryImpl());

  // Presentation

  // shared
  /// School Feature Routes
  static final Provider<ApplicationRoutes> routes =
      Provider<ProductSelectionRoutes>(
    (ref) => ProductSelectionRoutes(),
  );
}
