import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/shopping/data/models/order_item_model.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_status.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.status,
    required this.items,
    required this.itemCount,
    required this.placedAt,
    required this.currency,
    required this.total,
    this.receivedAt,
    this.addedToFridgeAt,
  });

  final String id;
  final OrderStatus status;
  final List<OrderItemModel> items;
  final int itemCount;
  final DateTime placedAt;
  final DateTime? receivedAt;
  final DateTime? addedToFridgeAt;
  final String currency;
  final num total;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json[ApiKeys.items] as List<dynamic>? ?? const [];
    final receivedRaw = json[ApiKeys.receivedAt] as String?;
    final addedRaw = json[ApiKeys.addedToFridgeAt] as String?;
    return OrderModel(
      id: json[ApiKeys.id] as String,
      status:
          OrderStatus.fromJson(json[ApiKeys.status] as String?) ??
          OrderStatus.placed,
      items: rawItems
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCount: json[ApiKeys.itemCount] as int,
      placedAt: DateTime.parse(json[ApiKeys.placedAt] as String),
      receivedAt: receivedRaw == null ? null : DateTime.parse(receivedRaw),
      addedToFridgeAt: addedRaw == null ? null : DateTime.parse(addedRaw),
      currency: json[ApiKeys.currency] as String,
      total: json[ApiKeys.total] as num,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      status: status,
      items: items.map((e) => e.toEntity()).toList(),
      itemCount: itemCount,
      placedAt: placedAt,
      receivedAt: receivedAt,
      addedToFridgeAt: addedToFridgeAt,
      currency: currency,
      total: total,
    );
  }
}
