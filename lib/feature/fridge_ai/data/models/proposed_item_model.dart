import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class ProposedItemModel {
  ProposedItemModel({
    required this.id,
    required this.name,
    this.quantity,
    this.unit,
    this.category,
    this.expiresAt,
    this.emoji,
  });

  final String id;
  final String name;
  final num? quantity;
  final String? unit;
  final String? category;
  final String? expiresAt;
  final String? emoji;

  factory ProposedItemModel.fromJson(Map<String, dynamic> json) {
    return ProposedItemModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      quantity: json[ApiKeys.quantity] as num?,
      unit: json[ApiKeys.unit] as String?,
      category: json[ApiKeys.category] as String?,
      expiresAt: json[ApiKeys.expiresAt] as String?,
      emoji: json[ApiKeys.emoji] as String?,
    );
  }

  ProposedItemEntity toEntity() {
    return ProposedItemEntity(
      id: id,
      name: name,
      quantity: quantity,
      unit: FoodUnit.fromJson(unit),
      category: FoodCategory.fromJson(category),
      expiresAt: expiresAt == null ? null : DateTime.tryParse(expiresAt!),
      emoji: emoji,
    );
  }
}
