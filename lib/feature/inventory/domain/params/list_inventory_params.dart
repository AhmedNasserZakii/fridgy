import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_sort.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_status_filter.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class ListInventoryParams extends Equatable {
  const ListInventoryParams({
    this.storage,
    this.category,
    this.q,
    this.status,
    this.expiresWithinDays,
    this.sort = InventorySort.expiryAsc,
    this.includeOutOfStock = true,
    this.page = 1,
    this.limit = 20,
  });

  final StorageLocation? storage;
  final FoodCategory? category;
  final String? q;
  final InventoryStatusFilter? status;
  final int? expiresWithinDays;
  final InventorySort sort;
  final bool includeOutOfStock;
  final int page;
  final int limit;

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{
      ApiKeys.includeOutOfStock: includeOutOfStock,
      ApiKeys.sort: sort.apiValue,
      ApiKeys.page: page,
      ApiKeys.limit: limit,
    };
    if (storage != null) {
      query[ApiKeys.storage] = storage!.name;
    }
    if (category != null) {
      query[ApiKeys.category] = category!.toJson();
    }
    final trimmedQ = q?.trim();
    if (trimmedQ != null && trimmedQ.isNotEmpty) {
      query[ApiKeys.q] = trimmedQ;
    }
    if (status != null) {
      query[ApiKeys.status] = status!.apiValue;
    }
    if (expiresWithinDays != null) {
      query[ApiKeys.expiresWithinDays] = expiresWithinDays;
    }
    return query;
  }

  @override
  List<Object?> get props => [
        storage,
        category,
        q,
        status,
        expiresWithinDays,
        sort,
        includeOutOfStock,
        page,
        limit,
      ];
}
