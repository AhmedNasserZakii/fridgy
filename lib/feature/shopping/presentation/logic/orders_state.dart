import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_entity.dart';

enum OrdersStatus { loading, success, empty, failure }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.loading,
    this.orders = const [],
    this.meta,
    this.message,
  });

  final OrdersStatus status;
  final List<OrderEntity> orders;
  final PaginationMeta? meta;
  final String? message;

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? orders,
    PaginationMeta? meta,
    String? message,
    bool clearMessage = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      meta: meta ?? this.meta,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, orders, meta, message];
}
