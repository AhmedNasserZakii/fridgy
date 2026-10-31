import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/logic/more_cubit.dart';

class MoreProfileHeader extends StatelessWidget {
  const MoreProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.onTap,
  });

  final String name;
  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surfaceAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                MoreCubit.initialsFor(name),
                style: AppTextStyles.titleBold20.copyWith(
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.titleBold26),
                  const SizedBox(height: 4),
                  Text(email, style: AppTextStyles.secondaryBodyRegular14Text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
