import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';

part 'product_model.g.dart';

/// Post Model to persist Data in Backend
@freezed
// ignore_for_file: invalid_annotation_target
class ProductModel with _$ProductModel {
  /// Create Post Model
  factory ProductModel({
    @JsonKey(name: 'productName') required String productName,
    @JsonKey(name: 'productDescription') required String productDescription,
    @JsonKey(name: 'accessoriesDescription')
    required String accessoriesDescription,
    @JsonKey(name: 'productPrice') required double productPrice,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: r'$id') String? id,
    @JsonKey(name: 'productImageIds')
    @Default([])
    List<String?> productImageIds,
    @JsonKey(name: 'accessoriesImageIds')
    @Default([])
    List<String?> accessoriesImageIds,
  }) = _ProductModel;

  /// Convert [ProductModel] fromJson
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
