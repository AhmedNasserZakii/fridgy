import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/shopping/data/models/cart_item_model.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_entity.dart';

class CartModel {
  const CartModel({
    required this.id,
    required this.items,
    required this.itemCount,
    required this.subtotal,
    required this.currency,
    required this.updatedAt,
  });

  final String id;
  final List<CartItemModel> items;
  final int itemCount;
  final num subtotal;
  final String currency;
  final DateTime updatedAt;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json[ApiKeys.items] as List<dynamic>? ?? const [];
    return CartModel(
      id: json[ApiKeys.id] as String,
      items: rawItems
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCount: json[ApiKeys.itemCount] as int,
      subtotal: json[ApiKeys.subtotal] as num,
      currency: json[ApiKeys.currency] as String,
      updatedAt: DateTime.parse(json[ApiKeys.updatedAt] as String),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items.map((e) => e.toEntity()).toList(),
      itemCount: itemCount,
      subtotal: subtotal,
      currency: currency,
      updatedAt: updatedAt,
    );
  }
}
