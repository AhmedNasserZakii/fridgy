import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgeAiHeader extends StatelessWidget {
  const FridgeAiHeader({super.key, this.onBack, this.onHistory});

  final VoidCallback? onBack;
  final VoidCallback? onHistory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 11, 8, 11),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.icChevronLeft,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    LocaleKeys.back.tr(),
                    style: AppTextStyles.appBarActionRegular17,
                  ),
                ],
              ),
            ),
          ),
          Text(
            LocaleKeys.fridgeAiTitle.tr(),
            style: AppTextStyles.appBarTitleSemiBold17,
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onHistory,
              style: TextButton.styleFrom(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 11, 16, 11),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                LocaleKeys.history.tr(),
                style: AppTextStyles.appBarActionRegular17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
