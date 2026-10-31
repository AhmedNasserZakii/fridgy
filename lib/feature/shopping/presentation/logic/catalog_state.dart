import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';

enum CatalogStatus { loading, loadingMore, success, empty, failure }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.loading,
    this.items = const [],
    this.meta,
    this.message,
    this.query = '',
    this.category,
  });

  final CatalogStatus status;
  final List<CatalogProductEntity> items;
  final PaginationMeta? meta;
  final String? message;
  final String query;
  final FoodCategory? category;

  bool get hasMore => meta?.hasMore ?? false;

  CatalogState copyWith({
    CatalogStatus? status,
    List<CatalogProductEntity>? items,
    PaginationMeta? meta,
    String? message,
    String? query,
    FoodCategory? category,
    bool clearMessage = false,
    bool clearCategory = false,
  }) {
    return CatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      message: clearMessage ? null : (message ?? this.message),
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
    );
  }

  @override
  List<Object?> get props => [status, items, meta, message, query, category];
}
