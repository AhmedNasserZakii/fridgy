import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class FridgeAiHistoryTile extends StatelessWidget {
  const FridgeAiHistoryTile({
    required this.conversation,
    required this.onTap,
    super.key,
  });

  final ConversationSummaryEntity conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final modeLabel = conversation.mode == FridgeAiMode.addFood
        ? LocaleKeys.fridgeAiModeAddFood.tr()
        : LocaleKeys.fridgeAiModeUseFood.tr();

    return Material(
      color: AppColors.surfaceDefault,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  conversation.title,
                  style: AppTextStyles.bodySemiBold16Primary,
                ),
                const SizedBox(height: 4),
                Text(
                  conversation.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.secondaryBodyRegular14Text,
                ),
                const SizedBox(height: 8),
                Text(modeLabel, style: AppTextStyles.captionSemiBold12Brand),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
