import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class RecentSearchRow extends StatelessWidget {
  const RecentSearchRow({required this.query, required this.onTap, super.key});

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.icHistory, width: 22, height: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(query, style: AppTextStyles.bodySemiBold16Primary),
            ),
          ],
        ),
      ),
    );
  }
}
