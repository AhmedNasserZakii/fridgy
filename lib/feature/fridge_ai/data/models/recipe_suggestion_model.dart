import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/recipe_suggestion_entity.dart';

class RecipeSuggestionModel {
  RecipeSuggestionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.usesItemIds,
  });

  final String id;
  final String title;
  final String description;
  final List<String> usesItemIds;

  factory RecipeSuggestionModel.fromJson(Map<String, dynamic> json) {
    final rawIds = json[ApiKeys.usesItemIds];
    return RecipeSuggestionModel(
      id: json[ApiKeys.id] as String,
      title: json[ApiKeys.title] as String,
      description: json[ApiKeys.description] as String,
      usesItemIds: rawIds is List
          ? rawIds.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  RecipeSuggestionEntity toEntity() {
    return RecipeSuggestionEntity(
      id: id,
      title: title,
      description: description,
      usesItemIds: usesItemIds,
    );
  }
}
