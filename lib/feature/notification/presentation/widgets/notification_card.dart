import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/presentation/utils/notification_formatters.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeLabel = NotificationFormatters.typeLabel(notification.type);
    final time = DateFormat('h:mm a').format(notification.createdAt.toLocal());
    final footer = typeLabel.isEmpty ? time : '$time · $typeLabel';

    final imageUrl = notification.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Material(
      color: notification.isRead
          ? AppColors.backgroundSecondary
          : AppColors.surfaceAccent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (hasImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 54,
                          height: 54,
                          color: AppColors.borderDefault,
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: 54,
                          height: 54,
                          color: AppColors.borderDefault,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    SvgPicture.asset(
                      NotificationFormatters.fallbackIcon(notification.type),
                      width: 22,
                      height: 22,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppTextStyles.bodySemiBold16Primary,
                        ),
                        Text(
                          notification.body,
                          style: AppTextStyles.captionRegular12,
                        ),
                      ],
                    ),
                  ),
                  if (notification.action != null) ...[
                    const SizedBox(width: 12),
                    SvgPicture.asset(
                      AppAssets.icChevronRight,
                      width: 18,
                      height: 18,
                      matchTextDirection: true,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(footer, style: AppTextStyles.captionRegular12),
            ],
          ),
        ),
      ),
    );
  }
}
