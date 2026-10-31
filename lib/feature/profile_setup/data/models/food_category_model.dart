import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/food_category_entity.dart';

class FoodCategoryModel {
  const FoodCategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
  });

  final String id;
  final String name;
  final String emoji;

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      emoji: json[ApiKeys.emoji] as String,
    );
  }

  FoodCategoryEntity toEntity() {
    return FoodCategoryEntity(id: id, name: name, emoji: emoji);
  }
}
