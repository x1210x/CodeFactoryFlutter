import 'package:codefactory_flutter/common/model/model_with_id.dart';
import 'package:codefactory_flutter/common/utils/data_utils.dart';
import 'package:codefactory_flutter/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel implements IModelWithId {
  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.restaurant,
    //required this.createdAt,
  });

  final String id;
  final List<OrderProductAndCountModel> products;
  final int totalPrice;
  final RestaurantModel restaurant;
  //@JsonKey(fromJson: DataUtils.stringToDateTime) final DateTime createdAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

@JsonSerializable()
class OrderProductModel {
  OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  final String id;
  final String name;
  final String detail;
  @JsonKey(fromJson: DataUtils.pathToUrl)final String imgUrl;
  final int price;

  factory OrderProductModel.fromJson(Map<String, dynamic> json) => _$OrderProductModelFromJson(json);
}

@JsonSerializable()
class OrderProductAndCountModel {
  OrderProductAndCountModel({
    required this.product,
    required this.count,
  });

  final OrderProductModel product;
  final int count;

  factory OrderProductAndCountModel.fromJson(Map<String, dynamic> json) => _$OrderProductAndCountModelFromJson(json);
}