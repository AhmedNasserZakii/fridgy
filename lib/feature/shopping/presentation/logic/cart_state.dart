import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_entity.dart';

enum CartStatus { loading, success, empty, failure }

enum CartActionStatus { idle, working, orderPlaced, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.loading,
    this.cart,
    this.message,
    this.actionStatus = CartActionStatus.idle,
    this.placedOrder,
  });

  final CartStatus status;
  final CartEntity? cart;
  final String? message;
  final CartActionStatus actionStatus;
  final OrderEntity? placedOrder;

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? message,
    CartActionStatus? actionStatus,
    OrderEntity? placedOrder,
    bool clearMessage = false,
    bool clearPlacedOrder = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      message: clearMessage ? null : (message ?? this.message),
      actionStatus: actionStatus ?? this.actionStatus,
      placedOrder: clearPlacedOrder ? null : (placedOrder ?? this.placedOrder),
    );
  }

  @override
  List<Object?> get props => [status, cart, message, actionStatus, placedOrder];
}
