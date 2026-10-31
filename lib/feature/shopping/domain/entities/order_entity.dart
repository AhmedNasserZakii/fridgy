import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_item_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_status.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
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
  final List<OrderItemEntity> items;
  final int itemCount;
  final DateTime placedAt;
  final DateTime? receivedAt;
  final DateTime? addedToFridgeAt;
  final String currency;
  final num total;

  bool get canMarkReceived => status == OrderStatus.placed;
  bool get canAddToFridge =>
      status == OrderStatus.placed || status == OrderStatus.received;

  @override
  List<Object?> get props => [
    id,
    status,
    items,
    itemCount,
    placedAt,
    receivedAt,
    addedToFridgeAt,
    currency,
    total,
  ];
}
