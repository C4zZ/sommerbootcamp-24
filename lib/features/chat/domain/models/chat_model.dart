import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// Chat Message Model
@freezed
// ignore_for_file: invalid_annotation_target
class ChatModel with _$ChatModel {
  /// Construct Chat Message Model
  factory ChatModel({
    @JsonKey(name: r'$id') required String id,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'receiver_id') required String receiverId,
    required String message,
    @JsonKey(name: r'$createdAt') required DateTime createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isSender,
  }) = _ChatModel;

  /// Convert [ChatModel] fromJson
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
