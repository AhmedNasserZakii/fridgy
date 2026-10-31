import 'package:equatable/equatable.dart';

class SuggestionEntity extends Equatable {
  const SuggestionEntity({
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

  @override
  List<Object?> get props => [id, title, description, recipeId, usesItemIds];
}
