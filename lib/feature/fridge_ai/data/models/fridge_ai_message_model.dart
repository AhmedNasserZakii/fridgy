import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/data/models/clarification_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/proposed_consumption_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/proposed_item_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/recipe_suggestion_model.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_reply_kind.dart';

class FridgeAiMessageModel {
  FridgeAiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.replyKind,
    this.imageUrl,
    this.proposedItems,
    this.recipeSuggestions,
    this.proposedConsumptions,
    this.clarification,
  });

  final String id;
  final String role;
  final String content;
  final String createdAt;
  final String? replyKind;
  final String? imageUrl;
  final List<ProposedItemModel>? proposedItems;
  final List<RecipeSuggestionModel>? recipeSuggestions;
  final List<ProposedConsumptionModel>? proposedConsumptions;
  final ClarificationModel? clarification;

  factory FridgeAiMessageModel.fromJson(Map<String, dynamic> json) {
    final clarificationRaw = json[ApiKeys.clarification];
    return FridgeAiMessageModel(
      id: json[ApiKeys.id] as String,
      role: json[ApiKeys.role] as String,
      content: json[ApiKeys.content] as String,
      createdAt: json[ApiKeys.createdAt] as String,
      replyKind: json[ApiKeys.replyKind] as String?,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      proposedItems: _mapList(
        json[ApiKeys.proposedItems],
        ProposedItemModel.fromJson,
      ),
      recipeSuggestions: _mapList(
        json[ApiKeys.recipeSuggestions],
        RecipeSuggestionModel.fromJson,
      ),
      proposedConsumptions: _mapList(
        json[ApiKeys.proposedConsumptions],
        ProposedConsumptionModel.fromJson,
      ),
      clarification: clarificationRaw is Map
          ? ClarificationModel.fromJson(
              Map<String, dynamic>.from(clarificationRaw),
            )
          : null,
    );
  }

  FridgeAiMessageEntity toEntity() {
    return FridgeAiMessageEntity(
      id: id,
      role: role == 'user'
          ? FridgeAiMessageRole.user
          : FridgeAiMessageRole.assistant,
      content: content,
      createdAt: DateTime.parse(createdAt),
      replyKind: FridgeAiReplyKind.fromApi(replyKind),
      imageUrl: imageUrl,
      proposedItems: proposedItems?.map((e) => e.toEntity()).toList(),
      recipeSuggestions: recipeSuggestions?.map((e) => e.toEntity()).toList(),
      proposedConsumptions:
          proposedConsumptions?.map((e) => e.toEntity()).toList(),
      clarification: clarification?.toEntity(),
    );
  }

  static List<T>? _mapList<T>(
    Object? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null) return null;
    if (raw is! List) return null;
    return raw
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
