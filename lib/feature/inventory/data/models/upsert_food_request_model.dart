import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/params/upsert_food_params.dart';

class UpsertFoodRequestModel {
  const UpsertFoodRequestModel({required this.params});

  final UpsertFoodParams params;

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: params.name,
      ApiKeys.category: params.category?.toJson(),
      ApiKeys.quantity: params.quantity,
      ApiKeys.unit: params.unit?.name,
      ApiKeys.storage: params.storage?.name,
      ApiKeys.purchaseDate: _dateOnly(params.purchaseDate),
      ApiKeys.expiryDate: _dateOnly(params.expiryDate),
      ApiKeys.imageUrl: params.imageUrl,
      ApiKeys.isPartlyUsed: params.isPartlyUsed,
    };
  }

  static String? _dateOnly(DateTime? date) {
    if (date == null) return null;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
