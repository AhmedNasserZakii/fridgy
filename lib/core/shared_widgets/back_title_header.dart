import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class BackTitleHeader extends StatelessWidget {
  const BackTitleHeader({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              icon: SvgPicture.asset(
                AppAssets.icChevronLeft,
                width: 24,
                height: 24,
              ),
            )
          else
            const SizedBox(width: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.titleBold20)),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
