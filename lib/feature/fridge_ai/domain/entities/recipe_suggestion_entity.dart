import 'package:equatable/equatable.dart';

class RecipeSuggestionEntity extends Equatable {
  const RecipeSuggestionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.usesItemIds,
  });

  final String id;
  final String title;
  final String description;
  final List<String> usesItemIds;

  @override
  List<Object?> get props => [id, title, description, usesItemIds];
}
