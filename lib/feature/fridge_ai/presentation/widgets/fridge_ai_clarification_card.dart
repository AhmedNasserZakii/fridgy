import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/clarification_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/quick_reply_entity.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_quick_reply_chip.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_soft_button.dart';

class FridgeAiClarificationCard extends StatelessWidget {
  const FridgeAiClarificationCard({
    required this.clarification,
    required this.onQuickReply,
    required this.onOther,
    required this.onCancel,
    super.key,
  });

  final ClarificationEntity clarification;
  final ValueChanged<QuickReplyEntity> onQuickReply;
  final VoidCallback onOther;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDefault,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  for (var i = 0;
                      i < clarification.quickReplies.length;
                      i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(
                      child: FridgeAiQuickReplyChip(
                        reply: clarification.quickReplies[i],
                        onTap: () {
                          final reply = clarification.quickReplies[i];
                          if (reply.message == null) {
                            onOther();
                          } else {
                            onQuickReply(reply);
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
              if (clarification.hint != null) ...[
                const SizedBox(height: 12),
                Text(
                  clarification.hint!,
                  style: AppTextStyles.metadataMedium13,
                ),
              ],
            ],
          ),
        ),
        if (clarification.note != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppAssets.icInfo,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    clarification.note!,
                    style: AppTextStyles.metadataMedium13.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (clarification.cancelLabel != null) ...[
          const SizedBox(height: 12),
          FridgeAiSoftButton(
            label: clarification.cancelLabel!,
            onPressed: onCancel,
          ),
        ],
      ],
    );
  }
}
