import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class MyFridgeHeader extends StatelessWidget {
  const MyFridgeHeader({required this.onAddTap, super.key});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.myFridgeTitle.tr(),
            style: AppTextStyles.titleBold20,
          ),
        ),
        IconButton(
          onPressed: onAddTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          icon: SvgPicture.asset(AppAssets.icPlus, width: 24, height: 24),
        ),
      ],
    );
  }
}
