import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class FoodItemModel {
  const FoodItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isPartlyUsed,
    required this.addedAt,
    this.imageUrl,
    this.unit,
    this.storage,
    this.category,
    this.purchaseDate,
    this.expiryDate,
    this.daysLeft,
    this.expiryStatus,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final StorageLocation? storage;
  final FoodCategory? category;
  final DateTime? purchaseDate;
  final bool isPartlyUsed;
  final DateTime? expiryDate;
  final int? daysLeft;
  final ExpiryStatus? expiryStatus;
  final DateTime addedAt;

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    final expiryRaw = json[ApiKeys.expiryDate] as String?;
    final purchaseRaw = json[ApiKeys.purchaseDate] as String?;
    return FoodItemModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      quantity: json[ApiKeys.quantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      storage: StorageLocation.fromJson(json[ApiKeys.storage] as String?),
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      purchaseDate: purchaseRaw == null ? null : DateTime.parse(purchaseRaw),
      isPartlyUsed: json[ApiKeys.isPartlyUsed] as bool,
      expiryDate: expiryRaw == null ? null : DateTime.parse(expiryRaw),
      daysLeft: json[ApiKeys.daysLeft] as int?,
      expiryStatus: ExpiryStatus.fromJson(
        json[ApiKeys.expiryStatus] as String?,
      ),
      addedAt: DateTime.parse(json[ApiKeys.addedAt] as String),
    );
  }

  FoodItemEntity toEntity() {
    return FoodItemEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      storage: storage,
      category: category,
      purchaseDate: purchaseDate,
      isPartlyUsed: isPartlyUsed,
      expiryDate: expiryDate,
      daysLeft: daysLeft,
      expiryStatus: expiryStatus,
      addedAt: addedAt,
    );
  }
}
