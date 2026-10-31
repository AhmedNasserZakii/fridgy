import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/clarification_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_reply_kind.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_consumption_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/recipe_suggestion_entity.dart';

class SendMessageResultEntity extends Equatable {
  const SendMessageResultEntity({
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
  final FridgeAiMode mode;
  final FridgeAiMessageEntity userMessage;
  final FridgeAiMessageEntity assistantMessage;
  final FridgeAiReplyKind replyKind;
  final List<ProposedItemEntity>? proposedItems;
  final List<RecipeSuggestionEntity>? recipeSuggestions;
  final List<ProposedConsumptionEntity>? proposedConsumptions;
  final ClarificationEntity? clarification;

  @override
  List<Object?> get props => [
        conversationId,
        mode,
        userMessage,
        assistantMessage,
        replyKind,
        proposedItems,
        recipeSuggestions,
        proposedConsumptions,
        clarification,
      ];
}
