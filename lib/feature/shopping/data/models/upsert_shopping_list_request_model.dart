import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/shopping/domain/params/upsert_shopping_list_item_params.dart';

class UpsertShoppingListRequestModel {
  const UpsertShoppingListRequestModel({required this.params});

  final UpsertShoppingListItemParams params;

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: params.name,
      ApiKeys.quantity: params.quantity,
      ApiKeys.unit: params.unit?.name,
      ApiKeys.category: params.category?.toJson(),
      ApiKeys.imageUrl: params.imageUrl,
      ApiKeys.catalogProductId: params.catalogProductId,
      ApiKeys.notes: params.notes,
    };
  }
}
