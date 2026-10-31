import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_mode_segment_tab.dart';

class FridgeAiModeSegment extends StatelessWidget {
  const FridgeAiModeSegment({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final FridgeAiMode mode;
  final ValueChanged<FridgeAiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: FridgeAiModeSegmentTab(
              label: LocaleKeys.fridgeAiModeAddFood.tr(),
              selected: mode == FridgeAiMode.addFood,
              onTap: () => onChanged(FridgeAiMode.addFood),
            ),
          ),
          Expanded(
            child: FridgeAiModeSegmentTab(
              label: LocaleKeys.fridgeAiModeUseFood.tr(),
              selected: mode == FridgeAiMode.useFood,
              onTap: () => onChanged(FridgeAiMode.useFood),
            ),
          ),
        ],
      ),
    );
  }
}
