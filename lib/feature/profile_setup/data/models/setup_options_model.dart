import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/profile_setup/data/models/food_category_model.dart';
import 'package:fridgy/feature/profile_setup/data/models/option_model.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/setup_options_entity.dart';

class SetupOptionsModel {
  const SetupOptionsModel({
    required this.foodCategories,
    required this.diets,
    required this.avoidIngredients,
  });

  final List<FoodCategoryModel> foodCategories;
  final List<OptionModel> diets;
  final List<OptionModel> avoidIngredients;

  factory SetupOptionsModel.fromJson(Map<String, dynamic> json) {
    return SetupOptionsModel(
      foodCategories: (json[ApiKeys.foodCategories] as List<dynamic>)
          .map((e) => FoodCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      diets: (json[ApiKeys.diets] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      avoidIngredients: (json[ApiKeys.avoidIngredients] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  SetupOptionsEntity toEntity() {
    return SetupOptionsEntity(
      foodCategories: foodCategories.map((e) => e.toEntity()).toList(),
      diets: diets.map((e) => e.toEntity()).toList(),
      avoidIngredients: avoidIngredients.map((e) => e.toEntity()).toList(),
    );
  }
}
