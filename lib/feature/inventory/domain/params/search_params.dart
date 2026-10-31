import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/api_keys.dart';

class SearchParams extends Equatable {
  const SearchParams({
    required this.q,
    this.includeOutOfStock = false,
    this.page = 1,
    this.limit = 20,
  });

  final String q;
  final bool includeOutOfStock;
  final int page;
  final int limit;

  Map<String, dynamic> toQuery() {
    return {
      ApiKeys.q: q,
      ApiKeys.includeOutOfStock: includeOutOfStock,
      ApiKeys.page: page,
      ApiKeys.limit: limit,
    };
  }

  @override
  List<Object?> get props => [q, includeOutOfStock, page, limit];
}
