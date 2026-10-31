import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';

class ListCatalogParams {
  const ListCatalogParams({
    this.q,
    this.category,
    this.page = 1,
    this.limit = 20,
  });

  final String? q;
  final FoodCategory? category;
  final int page;
  final int limit;

  Map<String, dynamic> toQuery() {
    return {
      if (q != null && q!.trim().isNotEmpty) ApiKeys.q: q!.trim(),
      if (category != null) ApiKeys.category: category!.toJson(),
      ApiKeys.page: page,
      ApiKeys.limit: limit,
    };
  }
}
