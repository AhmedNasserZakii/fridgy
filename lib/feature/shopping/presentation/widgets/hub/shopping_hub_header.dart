import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class ShoppingHubHeader extends StatelessWidget {
  const ShoppingHubHeader({
    required this.cartCount,
    required this.onCartTap,
    required this.onOrdersTap,
    super.key,
  });

  final int cartCount;
  final VoidCallback onCartTap;
  final VoidCallback onOrdersTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.navShopping.tr(),
            style: AppTextStyles.titleBold20,
          ),
        ),
        IconButton(
          onPressed: onOrdersTap,
          tooltip: LocaleKeys.shoppingOrders.tr(),
          icon: SvgPicture.asset(
            AppAssets.icShoppingBag,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onCartTap,
              tooltip: LocaleKeys.shoppingCart.tr(),
              icon: SvgPicture.asset(
                AppAssets.icNavCart,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (cartCount > 0)
              PositionedDirectional(
                top: 8,
                end: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    cartCount > 9 ? '9+' : '$cartCount',
                    style: AppTextStyles.secondaryBodyRegular14Text.copyWith(
                      color: AppColors.textInverse,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
