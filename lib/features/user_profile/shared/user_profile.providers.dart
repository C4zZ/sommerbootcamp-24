import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/shared.dart';
import '../data.dart';
import '../domain.dart';

/// User Profile Feature Providers
class UserProfileProviders {
  // Data

  /// User Profile Remote Datasource
  static final Provider<UserProfileDatasource> userProfileRemoteDatasource =
      Provider((ref) => UserProfileRemoteDatasource());

  // Domain
  /// User Profile Repository
  static final Provider<UserProfileRepository> userProfileRepository = Provider(
    (ref) => UserProfileRepositoryImpl(
      appwriteClient: ref.refresh(CoreProviders.appwrite),
    ),
  );

  // Presentation
}
