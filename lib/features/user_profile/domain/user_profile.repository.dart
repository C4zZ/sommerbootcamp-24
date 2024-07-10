import 'dart:typed_data';

import 'models/user_profile_model.dart';

/// User Profile Repository
abstract class UserProfileRepository {
  /// Get all User Profiles
  Future<List<UserProfileModel>> getProfileList();

  /// Get User Profile from user id [userId]
  Future<UserProfileModel?> getUserProfile(String userId);

  /// Get User Profile Image
  Future<Uint8List> getProfileImageFromImageId(
    String profileImageId, {
    bool fromCache,
  });

  /// Get User Profile Image from User Id
  Future<Uint8List> getProfileImageFromUserId(
    String userId, {
    bool fromCache,
  });
}
