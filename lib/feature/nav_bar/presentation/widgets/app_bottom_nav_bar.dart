import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/nav_bar/presentation/widgets/nav_bar_item.dart';
import 'package:fridgy/feature/nav_bar/presentation/widgets/nav_center_button.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onCenterTap,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72 + 25,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 72,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              decoration: const BoxDecoration(
                color: AppColors.surfaceDefault,
                border: Border(top: BorderSide(color: AppColors.borderDefault)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NavBarItem(
                    iconAsset: AppAssets.icNavHome,
                    label: LocaleKeys.navHome.tr(),
                    selected: selectedIndex == 0,
                    onTap: () => onSelect(0),
                  ),
                  NavBarItem(
                    iconAsset: AppAssets.icNavFridge,
                    label: LocaleKeys.navMyFridge.tr(),
                    selected: selectedIndex == 1,
                    onTap: () => onSelect(1),
                  ),
                  const SizedBox(width: 64),
                  NavBarItem(
                    iconAsset: AppAssets.icNavCart,
                    label: LocaleKeys.navShopping.tr(),
                    selected: selectedIndex == 2,
                    onTap: () => onSelect(2),
                  ),
                  NavBarItem(
                    iconAsset: AppAssets.icNavMenu,
                    label: LocaleKeys.navMore.tr(),
                    selected: selectedIndex == 3,
                    onTap: () => onSelect(3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: NavCenterButton(onTap: onCenterTap)),
          ),
        ],
      ),
    );
  }
}
