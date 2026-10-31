import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/home/presentation/widgets/notification_bell.dart';

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    required this.user,
    required this.hasUnreadNotifications,
    required this.onBellTap,
    super.key,
  });

  final UserEntity? user;
  final bool hasUnreadNotifications;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting(user), style: AppTextStyles.titleBold26),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.homeGreetingSubtitle.tr(),
                style: AppTextStyles.captionRegular12,
              ),
            ],
          ),
        ),
        NotificationBell(hasUnread: hasUnreadNotifications, onTap: onBellTap),
      ],
    );
  }

  static String _greeting(UserEntity? user) {
    final firstName = _firstName(user?.name);
    final hour = DateTime.now().hour;
    final key = hour >= 5 && hour < 12
        ? LocaleKeys.goodMorningNamed
        : hour >= 12 && hour < 17
        ? LocaleKeys.goodAfternoonNamed
        : LocaleKeys.goodEveningNamed;
    return key.tr(args: [firstName.isEmpty ? '' : firstName]);
  }

  static String _firstName(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    return name.trim().split(RegExp(r'\s+')).first;
  }
}
