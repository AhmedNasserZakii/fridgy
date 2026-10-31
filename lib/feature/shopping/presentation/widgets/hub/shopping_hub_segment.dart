import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_mode_segment_tab.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_hub_tab.dart';

class ShoppingHubSegment extends StatelessWidget {
  const ShoppingHubSegment({
    required this.tab,
    required this.onChanged,
    super.key,
  });

  final ShoppingHubTab tab;
  final ValueChanged<ShoppingHubTab> onChanged;

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
              label: LocaleKeys.shoppingTabList.tr(),
              selected: tab == ShoppingHubTab.list,
              onTap: () => onChanged(ShoppingHubTab.list),
            ),
          ),
          Expanded(
            child: FridgeAiModeSegmentTab(
              label: LocaleKeys.shoppingTabStore.tr(),
              selected: tab == ShoppingHubTab.store,
              onTap: () => onChanged(ShoppingHubTab.store),
            ),
          ),
        ],
      ),
    );
  }
}
