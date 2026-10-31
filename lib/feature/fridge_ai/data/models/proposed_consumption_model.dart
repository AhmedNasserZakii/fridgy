import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_consumption_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class ProposedConsumptionModel {
  ProposedConsumptionModel({
    required this.id,
    required this.inventoryItemId,
    required this.name,
    required this.quantity,
    this.unit,
  });

  final String id;
  final String inventoryItemId;
  final String name;
  final num quantity;
  final String? unit;

  factory ProposedConsumptionModel.fromJson(Map<String, dynamic> json) {
    return ProposedConsumptionModel(
      id: json[ApiKeys.id] as String,
      inventoryItemId: json[ApiKeys.inventoryItemId] as String,
      name: json[ApiKeys.name] as String,
      quantity: json[ApiKeys.quantity] as num,
      unit: json[ApiKeys.unit] as String?,
    );
  }

  ProposedConsumptionEntity toEntity() {
    return ProposedConsumptionEntity(
      id: id,
      inventoryItemId: inventoryItemId,
      name: name,
      quantity: quantity,
      unit: FoodUnit.fromJson(unit),
    );
  }
}
