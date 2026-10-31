import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/data/models/clarification_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/fridge_ai_message_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/proposed_consumption_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/proposed_item_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/recipe_suggestion_model.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_reply_kind.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/send_message_result_entity.dart';

class SendMessageResultModel {
  SendMessageResultModel({
    required this.conversationId,
    required this.mode,
    required this.userMessage,
    required this.assistantMessage,
    required this.replyKind,
    this.proposedItems,
    this.recipeSuggestions,
    this.proposedConsumptions,
    this.clarification,
  });

  final String conversationId;
  final String mode;
  final FridgeAiMessageModel userMessage;
  final FridgeAiMessageModel assistantMessage;
  final String replyKind;
  final List<ProposedItemModel>? proposedItems;
  final List<RecipeSuggestionModel>? recipeSuggestions;
  final List<ProposedConsumptionModel>? proposedConsumptions;
  final ClarificationModel? clarification;

  factory SendMessageResultModel.fromJson(Map<String, dynamic> json) {
    final clarificationRaw = json[ApiKeys.clarification];
    return SendMessageResultModel(
      conversationId: json[ApiKeys.conversationId] as String,
      mode: json[ApiKeys.mode] as String,
      userMessage: FridgeAiMessageModel.fromJson(
        Map<String, dynamic>.from(json[ApiKeys.userMessage] as Map),
      ),
      assistantMessage: FridgeAiMessageModel.fromJson(
        Map<String, dynamic>.from(json[ApiKeys.assistantMessage] as Map),
      ),
      replyKind: json[ApiKeys.replyKind] as String? ?? 'text',
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

  SendMessageResultEntity toEntity() {
    final kind = FridgeAiReplyKind.fromApi(replyKind);
    final proposed = proposedItems?.map((e) => e.toEntity()).toList();
    final recipes = recipeSuggestions?.map((e) => e.toEntity()).toList();
    final consumptions =
        proposedConsumptions?.map((e) => e.toEntity()).toList();
    final clarify = clarification?.toEntity();

    final assistant = assistantMessage.toEntity();
    return SendMessageResultEntity(
      conversationId: conversationId,
      mode: FridgeAiMode.fromApi(mode),
      userMessage: userMessage.toEntity(),
      assistantMessage: FridgeAiMessageEntity(
        id: assistant.id,
        role: assistant.role,
        content: assistant.content,
        createdAt: assistant.createdAt,
        replyKind: kind,
        proposedItems: proposed,
        recipeSuggestions: recipes,
        proposedConsumptions: consumptions,
        clarification: clarify,
      ),
      replyKind: kind,
      proposedItems: proposed,
      recipeSuggestions: recipes,
      proposedConsumptions: consumptions,
      clarification: clarify,
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
