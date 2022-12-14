import 'package:codefactory_flutter/user/model/basket_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class PostOrderBody {
  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createAt,
  });

  final String id;
  final List<PostOrderBodyProduct> products;
  final int totalPrice;
  final String createAt;

  factory PostOrderBody.fromJson(Map<String, dynamic> json) => _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderBodyProduct {
  PostOrderBodyProduct({
    required this.productId,
    required this.count
  });

  final String productId;
  final int count;

  factory PostOrderBodyProduct.fromJson(Map<String, dynamic> json) => _$PostOrderBodyProductFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyProductToJson(this);
}