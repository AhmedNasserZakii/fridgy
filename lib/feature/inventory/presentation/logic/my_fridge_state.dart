import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_sort.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_status_filter.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

enum MyFridgeStatus { loading, loadingMore, success, empty, failure }

class MyFridgeState extends Equatable {
  const MyFridgeState({
    this.status = MyFridgeStatus.loading,
    this.items = const [],
    this.meta,
    this.message,
    this.storage,
    this.category,
    this.query = '',
    this.statusFilter,
    this.expiresWithinDays,
    this.sort = InventorySort.expiryAsc,
  });

  final MyFridgeStatus status;
  final List<FoodItemEntity> items;
  final PaginationMeta? meta;
  final String? message;

  final StorageLocation? storage;
  final FoodCategory? category;
  final String query;
  final InventoryStatusFilter? statusFilter;
  final int? expiresWithinDays;
  final InventorySort sort;

  bool get hasMore => meta?.hasMore ?? false;

  int get activeCount => items.where((item) => item.quantity > 0).length;

  List<FoodItemEntity> get useSoonItems => items
      .where(
        (item) =>
            item.quantity > 0 && item.expiryStatus == ExpiryStatus.useSoon,
      )
      .toList();

  List<FoodItemEntity> get restItems => items
      .where(
        (item) =>
            item.quantity > 0 && item.expiryStatus != ExpiryStatus.useSoon,
      )
      .toList();

  List<FoodItemEntity> get outOfStockItems =>
      items.where((item) => item.quantity == 0).toList();

  bool get showFridgeEmpty =>
      status == MyFridgeStatus.success && activeCount == 0;

  MyFridgeState copyWith({
    MyFridgeStatus? status,
    List<FoodItemEntity>? items,
    PaginationMeta? meta,
    String? message,
    StorageLocation? storage,
    FoodCategory? category,
    String? query,
    InventoryStatusFilter? statusFilter,
    int? expiresWithinDays,
    InventorySort? sort,
    bool clearMessage = false,
    bool clearStorage = false,
    bool clearCategory = false,
    bool clearStatusFilter = false,
    bool clearExpiresWithinDays = false,
  }) {
    return MyFridgeState(
      status: status ?? this.status,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      message: clearMessage ? null : (message ?? this.message),
      storage: clearStorage ? null : (storage ?? this.storage),
      category: clearCategory ? null : (category ?? this.category),
      query: query ?? this.query,
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      expiresWithinDays: clearExpiresWithinDays
          ? null
          : (expiresWithinDays ?? this.expiresWithinDays),
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        meta,
        message,
        storage,
        category,
        query,
        statusFilter,
        expiresWithinDays,
        sort,
      ];
}
