import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// User Profile Model
@freezed
// ignore_for_file: invalid_annotation_target
class UserProfileModel with _$UserProfileModel {
  /// Create UserProfileModel
  factory UserProfileModel({
    @JsonKey(name: r'$id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'profile_image_id') String? profileImageId,
  }) = _UserProfileModel;

  /// Convert [UserProfileModel] fromJson
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}
