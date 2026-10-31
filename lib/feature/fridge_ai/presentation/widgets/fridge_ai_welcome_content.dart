import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_mode_card.dart';

class FridgeAiWelcomeContent extends StatelessWidget {
  const FridgeAiWelcomeContent({required this.onSelectMode, super.key});

  final ValueChanged<FridgeAiMode> onSelectMode;

  @override
  Widget build(BuildContext context) {
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
          LocaleKeys.fridgeAiWelcomeHeading.tr(),
          style: AppTextStyles.titleBold28,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.fridgeAiWelcomeBody.tr(),
          style: AppTextStyles.bodyRegular17Secondary,
        ),
        const SizedBox(height: 22),
        FridgeAiModeCard(
          iconAsset: AppAssets.icShoppingBag,
          title: LocaleKeys.fridgeAiModeAddFood.tr(),
          body: LocaleKeys.fridgeAiAddFoodCardBody.tr(),
          onTap: () => onSelectMode(FridgeAiMode.addFood),
        ),
        const SizedBox(height: 12),
        FridgeAiModeCard(
          iconAsset: AppAssets.icCookingPot,
          title: LocaleKeys.fridgeAiModeUseFood.tr(),
          body: LocaleKeys.fridgeAiUseFoodCardBody.tr(),
          onTap: () => onSelectMode(FridgeAiMode.useFood),
        ),
      ],
    );
  }
}
