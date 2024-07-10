import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

import '../../core/shared.dart';
import '../domain/models/user_profile_model.dart';
import '../domain/user_profile.repository.dart';

/// Implementation of [UserProfileRepository]
class UserProfileRepositoryImpl implements UserProfileRepository {
  /// constructor
  UserProfileRepositoryImpl({required this.appwriteClient});
  static final Map<String, Uint8List> _cachedImages = <String, Uint8List>{};

  /// appwrite client
  final AppwriteClient appwriteClient;

  @override
  Future<UserProfileModel?> getUserProfile(String userId) async {
    final databases = appwriteClient.databases;

    final userIdQuery = Query.equal('user_id', userId);
    final userProfiles = await databases.listDocuments(
      databaseId: appwriteClient.databaseId,
      collectionId: appwriteClient.userProfileCollectionId,
      queries: [userIdQuery],
    );

    final userProfileModels = userProfiles.convertTo(
      (p0) => UserProfileModel.fromJson(p0 as Map<String, dynamic>),
    );
    return userProfileModels.first;
  }

  @override
  Future<Uint8List> getProfileImageFromImageId(
    String profileImageId, {
    bool fromCache = true,
  }) async {
    if (_cachedImages.containsKey(profileImageId) && fromCache) {
      return _cachedImages[profileImageId]!;
    }

    _cachedImages[profileImageId] =
        await appwriteClient.storage.getFileDownload(
      bucketId: appwriteClient.userBucketId,
      fileId: profileImageId,
    );

    return _cachedImages[profileImageId]!;
  }

  @override
  Future<Uint8List> getProfileImageFromUserId(
    String userId, {
    bool fromCache = true,
  }) async {
    try {
      final userProfile = await getUserProfile(userId);
      return getProfileImageFromImageId(
        userProfile!.profileImageId!,
        fromCache: fromCache,
      );
    } catch (e) {
      final userProfile = await getUserProfile(userId);
      return appwriteClient.avatars.getInitials(name: userProfile?.displayName);
    }
  }

  @override
  Future<List<UserProfileModel>> getProfileList() async {
    final userProfiles = await appwriteClient.databases.listDocuments(
      databaseId: appwriteClient.databaseId,
      collectionId: appwriteClient.userProfileCollectionId,
    );

    final userProfileModels = userProfiles.convertTo(
      (p0) => UserProfileModel.fromJson(p0 as Map<String, dynamic>),
    );

    return userProfileModels;
  }
}
