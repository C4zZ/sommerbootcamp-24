import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_contact_model.freezed.dart';

/// Chat Contact Model
@freezed
class ChatContactModel with _$ChatContactModel {
  /// construct chat contact model
  factory ChatContactModel({
    required String userId,
    required String displayName,
    @Default(null) Uint8List? profileImage,
  }) = _ChatContactModel;
}
