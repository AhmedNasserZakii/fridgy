import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/core/network_services/api_mode_controller.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

/// Switch between local mock data and the live API.
///
/// When [onChanged] is null the mode is applied directly; otherwise the
/// caller decides how to apply it (e.g. sign out first).
class ApiModeSwitch extends StatelessWidget {
  const ApiModeSwitch({super.key, this.onChanged, this.enabled = true});

  final ValueChanged<ApiMode>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<ApiModeController>();
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final isLive = controller.isLive;
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.apiModeTitle.tr(),
                      style: AppTextStyles.bodyRegular16Primary.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isLive
                          ? LocaleKeys.apiModeLiveSubtitle.tr()
                          : LocaleKeys.apiModeLocalSubtitle.tr(),
                      style: AppTextStyles.captionRegular12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Switch.adaptive(
                value: isLive,
                onChanged: enabled
                    ? (value) {
                        final mode = value ? ApiMode.live : ApiMode.local;
                        final handler = onChanged;
                        if (handler != null) {
                          handler(mode);
                        } else {
                          controller.setMode(mode);
                        }
                      }
                    : null,
                activeThumbColor: AppColors.textInverse,
                activeTrackColor: AppColors.brandPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}
