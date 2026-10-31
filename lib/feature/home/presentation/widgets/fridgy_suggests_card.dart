import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/home/domain/entities/suggestion_entity.dart';

class FridgySuggestsCard extends StatelessWidget {
  const FridgySuggestsCard({required this.suggestion, super.key});

  final SuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    // STOP: Figma has only one AI-content text slot (21:4384 = description).
    // Row title (21:4380) is fixed "Ask Fridgy" chrome, not suggestion.title.
    // Do not invent a second slot — waiting on contract/design decision.
    // Until then: render fixed Ask Fridgy row + description body only.
    // suggestion.title is parsed but not shown (no Figma slot).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(LocaleKeys.fridgySuggests.tr(), style: AppTextStyles.titleBold20),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () =>
                    AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.icSparkles,
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.askFridgy.tr(),
                              style: AppTextStyles.bodySemiBold16Primary,
                            ),
                            Text(
                              LocaleKeys.askFridgySubtitle.tr(),
                              style: AppTextStyles.captionRegular12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                suggestion.description,
                style: AppTextStyles.bodyRegular16Primary,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: Material(
                  color: AppColors.surfaceAccent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () =>
                        AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        LocaleKeys.showRecipe.tr(),
                        style: AppTextStyles.bodySemiBold16Brand,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.aiSuggestionDisclaimer.tr(),
                style: AppTextStyles.smallLabelSemiBold11.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
