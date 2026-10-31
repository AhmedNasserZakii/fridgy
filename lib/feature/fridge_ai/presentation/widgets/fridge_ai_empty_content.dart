import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_suggested_prompts.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_prompt_chip.dart';

class FridgeAiEmptyContent extends StatelessWidget {
  const FridgeAiEmptyContent({
    required this.mode,
    required this.onPromptTap,
    super.key,
  });

  final FridgeAiMode mode;
  final ValueChanged<String> onPromptTap;

  @override
  Widget build(BuildContext context) {
    final prompts = FridgeAiSuggestedPrompts.forMode(mode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        SvgPicture.asset(
          AppAssets.icFridgyAvatar,
          width: 64,
          height: 64,
          alignment: AlignmentDirectional.centerStart,
        ),
        const SizedBox(height: 22),
        Text(
          FridgeAiSuggestedPrompts.heading(mode),
          style: AppTextStyles.titleBold28,
        ),
        const SizedBox(height: 8),
        Text(
          FridgeAiSuggestedPrompts.body(mode),
          style: AppTextStyles.bodyRegular17Secondary,
        ),
        const SizedBox(height: 22),
        Text(
          LocaleKeys.fridgeAiTrySaying.tr(),
          style: AppTextStyles.metadataMedium13,
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < prompts.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          FridgeAiPromptChip(
            text: prompts[i],
            onTap: () => onPromptTap(prompts[i]),
          ),
        ],
      ],
    );
  }
}
