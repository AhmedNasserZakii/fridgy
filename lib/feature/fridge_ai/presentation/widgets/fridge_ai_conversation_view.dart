import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/quick_reply_entity.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_assistant_bubble.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_checking_note.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_clarification_card.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_proposed_consumptions_card.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_proposed_items_card.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_user_bubble.dart';

class FridgeAiConversationView extends StatelessWidget {
  const FridgeAiConversationView({
    required this.messages,
    required this.isSending,
    required this.isConfirming,
    required this.onConfirmItems,
    required this.onConfirmConsumptions,
    required this.onQuickReply,
    required this.onClarificationOther,
    required this.onClarificationCancel,
    super.key,
  });

  final List<FridgeAiMessageEntity> messages;
  final bool isSending;
  final bool isConfirming;
  final ValueChanged<FridgeAiMessageEntity> onConfirmItems;
  final ValueChanged<FridgeAiMessageEntity> onConfirmConsumptions;
  final ValueChanged<QuickReplyEntity> onQuickReply;
  final VoidCallback onClarificationOther;
  final ValueChanged<FridgeAiMessageEntity> onClarificationCancel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 8),
      itemCount: messages.length + (isSending ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (isSending && index == messages.length) {
          return const FridgeAiCheckingNote();
        }

        final message = messages[index];
        if (message.role == FridgeAiMessageRole.user) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FridgeAiUserBubble(
                content: message.content,
                imagePath: message.displayImagePath,
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.fridgeAiDelivered.tr(),
                textAlign: TextAlign.end,
                style: AppTextStyles.metadataMedium13,
              ),
            ],
          );
        }

        final items = message.proposedItems;
        final consumptions = message.proposedConsumptions;
        final recipes = message.recipeSuggestions ?? const [];
        final clarification = message.clarification;
        final isLatest = index == messages.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FridgeAiAssistantBubble(content: message.content),
            if (clarification != null && isLatest) ...[
              const SizedBox(height: 12),
              FridgeAiClarificationCard(
                clarification: clarification,
                onQuickReply: onQuickReply,
                onOther: onClarificationOther,
                onCancel: () => onClarificationCancel(message),
              ),
            ],
            if (items != null && items.isNotEmpty) ...[
              const SizedBox(height: 12),
              FridgeAiProposedItemsCard(
                items: items,
                isLoading: isConfirming,
                onConfirm: () => onConfirmItems(message),
              ),
            ],
            if ((consumptions != null && consumptions.isNotEmpty) ||
                recipes.isNotEmpty) ...[
              const SizedBox(height: 12),
              FridgeAiProposedConsumptionsCard(
                consumptions: consumptions ?? const [],
                recipes: recipes,
                isLoading: isConfirming,
                onConfirm: () => onConfirmConsumptions(message),
              ),
            ],
          ],
        );
      },
    );
  }
}
