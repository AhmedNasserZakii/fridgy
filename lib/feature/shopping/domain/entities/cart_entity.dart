import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  const CartEntity({
    required this.id,
    required this.items,
    required this.itemCount,
    required this.subtotal,
    required this.currency,
    required this.updatedAt,
  });

  final String id;
  final List<CartItemEntity> items;
  final int itemCount;
  final num subtotal;
  final String currency;
  final DateTime updatedAt;

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [
    id,
    items,
    itemCount,
    subtotal,
    currency,
    updatedAt,
  ];
}
