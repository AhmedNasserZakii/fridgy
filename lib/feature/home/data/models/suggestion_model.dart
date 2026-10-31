import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/home/domain/entities/suggestion_entity.dart';

class SuggestionModel {
  const SuggestionModel({
    required this.id,
    required this.title,
    required this.description,
    this.recipeId,
    this.usesItemIds = const [],
  });

  final String id;
  final String title;
  final String description;
  final String? recipeId;
  final List<String> usesItemIds;

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    final uses = json[ApiKeys.usesItemIds];
    return SuggestionModel(
      id: json[ApiKeys.id] as String,
      title: json[ApiKeys.title] as String,
      description: json[ApiKeys.description] as String,
      recipeId: json[ApiKeys.recipeId] as String?,
      usesItemIds: uses is List
          ? uses.map((e) => e.toString()).toList()
          : const [],
    );
  }

  SuggestionEntity toEntity() {
    return SuggestionEntity(
      id: id,
      title: title,
      description: description,
      recipeId: recipeId,
      usesItemIds: usesItemIds,
    );
  }
}
