import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';

enum SearchStatus { idle, loading, loadingMore, success, empty, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.idle,
    this.query = '',
    this.items = const [],
    this.meta,
    this.recentSearches = const [],
    this.firstName = '',
    this.message,
  });

  final SearchStatus status;
  final String query;
  final List<FoodItemEntity> items;
  final PaginationMeta? meta;
  final List<String> recentSearches;
  final String firstName;
  final String? message;

  bool get hasMore => meta?.hasMore ?? false;

  int get total => meta?.total ?? items.length;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<FoodItemEntity>? items,
    PaginationMeta? meta,
    List<String>? recentSearches,
    String? firstName,
    String? message,
    bool clearMeta = false,
    bool clearMessage = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      meta: clearMeta ? null : (meta ?? this.meta),
      recentSearches: recentSearches ?? this.recentSearches,
      firstName: firstName ?? this.firstName,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        items,
        meta,
        recentSearches,
        firstName,
        message,
      ];
}
