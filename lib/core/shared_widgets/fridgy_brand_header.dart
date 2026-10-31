import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class FridgyBrandHeader extends StatelessWidget {
  const FridgyBrandHeader({
    super.key,
    this.trailing,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppAssets.logoMark,
            width: 26,
            height: 27,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'FRIDGY',
            style: AppTextStyles.titleExtraBold20,
          ),
        ),
        ?trailing,
      ],
    );
  }
}
