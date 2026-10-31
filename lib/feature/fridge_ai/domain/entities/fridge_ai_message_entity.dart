import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/clarification_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_reply_kind.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_consumption_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/recipe_suggestion_entity.dart';

enum FridgeAiMessageRole { user, assistant }

class FridgeAiMessageEntity extends Equatable {
  const FridgeAiMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.replyKind = FridgeAiReplyKind.text,
    this.imageUrl,
    this.localImagePath,
    this.proposedItems,
    this.recipeSuggestions,
    this.proposedConsumptions,
    this.clarification,
  });

  final String id;
  final FridgeAiMessageRole role;
  final String content;
  final DateTime createdAt;
  final FridgeAiReplyKind replyKind;

  /// Remote image URL from the API (history / after upload).
  final String? imageUrl;

  /// Local file path kept on the client after picking/sending an image.
  final String? localImagePath;

  final List<ProposedItemEntity>? proposedItems;
  final List<RecipeSuggestionEntity>? recipeSuggestions;
  final List<ProposedConsumptionEntity>? proposedConsumptions;
  final ClarificationEntity? clarification;

  String? get displayImagePath => localImagePath ?? imageUrl;

  FridgeAiMessageEntity copyWith({
    String? id,
    FridgeAiMessageRole? role,
    String? content,
    DateTime? createdAt,
    FridgeAiReplyKind? replyKind,
    String? imageUrl,
    String? localImagePath,
    List<ProposedItemEntity>? proposedItems,
    List<RecipeSuggestionEntity>? recipeSuggestions,
    List<ProposedConsumptionEntity>? proposedConsumptions,
    ClarificationEntity? clarification,
  }) {
    return FridgeAiMessageEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      replyKind: replyKind ?? this.replyKind,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      proposedItems: proposedItems ?? this.proposedItems,
      recipeSuggestions: recipeSuggestions ?? this.recipeSuggestions,
      proposedConsumptions: proposedConsumptions ?? this.proposedConsumptions,
      clarification: clarification ?? this.clarification,
    );
  }

  @override
  List<Object?> get props => [
        id,
        role,
        content,
        createdAt,
        replyKind,
        imageUrl,
        localImagePath,
        proposedItems,
        recipeSuggestions,
        proposedConsumptions,
        clarification,
      ];
}
