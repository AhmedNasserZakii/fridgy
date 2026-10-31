import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

enum ExpiringSoonStatus { loading, loadingMore, success, empty, failure }

class ExpiringSoonState extends Equatable {
  const ExpiringSoonState({
    this.status = ExpiringSoonStatus.loading,
    this.items = const [],
    this.meta,
    this.message,
  });

  final ExpiringSoonStatus status;
  final List<FoodItemEntity> items;
  final PaginationMeta? meta;
  final String? message;

  bool get hasMore => meta?.hasMore ?? false;

  int get total => meta?.total ?? items.length;

  ExpiringSoonState copyWith({
    ExpiringSoonStatus? status,
    List<FoodItemEntity>? items,
    PaginationMeta? meta,
    String? message,
    bool clearMessage = false,
  }) {
    return ExpiringSoonState(
      status: status ?? this.status,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, items, meta, message];
}
