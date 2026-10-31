import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/food_category_entity.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/option_entity.dart';

class SetupOptionsEntity extends Equatable {
  const SetupOptionsEntity({
    required this.foodCategories,
    required this.diets,
    required this.avoidIngredients,
  });

  final List<FoodCategoryEntity> foodCategories;
  final List<OptionEntity> diets;
  final List<OptionEntity> avoidIngredients;

  @override
  List<Object?> get props => [foodCategories, diets, avoidIngredients];
}
