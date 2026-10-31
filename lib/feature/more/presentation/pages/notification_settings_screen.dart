import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/logic/notification_settings_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/notification_settings_state.dart';
import 'package:fridgy/feature/more/presentation/widgets/context_guidance_box.dart';
import 'package:fridgy/feature/more/presentation/widgets/settings_select_field.dart';
import 'package:fridgy/feature/more/presentation/widgets/settings_toggle_row.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  String _formatTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final isPm = hour >= 12;
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = isPm ? 'PM' : 'AM';
    return '$displayHour:${minute.padLeft(2, '0')} $suffix';
  }

  Future<void> _pickDays(BuildContext context, int current) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [1, 2, 3, 5, 7].map((days) {
              return ListTile(
                title: Text(LocaleKeys.remindDaysBefore.tr(args: ['$days'])),
                trailing: days == current
                    ? const Icon(Icons.check, color: AppColors.brandPrimary)
                    : null,
                onTap: () => Navigator.pop(context, days),
              );
            }).toList(),
          ),
        );
      },
    );
    if (selected != null && context.mounted) {
      await context.read<NotificationSettingsCubit>().setRemindDaysBefore(
        selected,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationSettingsCubit, NotificationSettingsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null &&
          current.status == NotificationSettingsStatus.loaded,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(
                    title: LocaleKeys.notificationSettings.tr(),
                  ),
                ),
                Expanded(child: _body(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, NotificationSettingsState state) {
    if (state.status == NotificationSettingsStatus.failure &&
        state.settings == null) {
      return InlineErrorView(
        message: state.errorMessage ?? LocaleKeys.anErrorOccurred.tr(),
        onRetry: () => context.read<NotificationSettingsCubit>().load(),
      );
    }

    final settings = state.settings;
    final loading = state.status == NotificationSettingsStatus.loading;

    return Skeletonizer(
      enabled: loading,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.icBellRing,
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.notificationsAllowed.tr(),
                            style: AppTextStyles.bodySemiBold16Primary,
                          ),
                          Text(
                            LocaleKeys.notificationsPermissionPreview.tr(),
                            style: AppTextStyles.captionRegular12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () =>
                      AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
                  child: Text(
                    LocaleKeys.openIosSettings.tr(),
                    style: AppTextStyles.captionRegular12.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(LocaleKeys.foodReminders.tr(), style: AppTextStyles.titleBold20),
          const SizedBox(height: 8),
          SettingsToggleRow(
            title: LocaleKeys.expiryReminders.tr(),
            subtitle: LocaleKeys.expiryRemindersSubtitle.tr(),
            value: settings?.expiryRemindersEnabled ?? true,
            onChanged: loading
                ? null
                : (value) => context
                      .read<NotificationSettingsCubit>()
                      .setExpiryReminders(value),
          ),
          if (settings?.expiryRemindersEnabled ?? true) ...[
            const SizedBox(height: 8),
            SettingsSelectField(
              label: LocaleKeys.remindMe.tr(),
              value: LocaleKeys.remindDaysBefore.tr(
                args: ['${settings?.remindDaysBefore ?? 2}'],
              ),
              onTap: loading
                  ? null
                  : () => _pickDays(context, settings?.remindDaysBefore ?? 2),
            ),
            const SizedBox(height: 16),
            SettingsSelectField(
              label: LocaleKeys.reminderTime.tr(),
              value: LocaleKeys.reminderTimeValue.tr(
                args: [_formatTime(settings?.reminderTime ?? '09:00')],
              ),
              onTap: () =>
                  AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
            ),
          ],
          const SizedBox(height: 16),
          Text(LocaleKeys.otherUpdates.tr(), style: AppTextStyles.titleBold20),
          const SizedBox(height: 8),
          SettingsToggleRow(
            title: LocaleKeys.shoppingListUpdates.tr(),
            subtitle: LocaleKeys.shoppingListUpdatesSubtitle.tr(),
            value: settings?.shoppingListUpdates ?? true,
            onChanged: loading
                ? null
                : (value) => context
                      .read<NotificationSettingsCubit>()
                      .setShoppingListUpdates(value),
          ),
          SettingsToggleRow(
            title: LocaleKeys.householdActivity.tr(),
            subtitle: LocaleKeys.householdActivitySubtitle.tr(),
            value: settings?.householdActivity ?? true,
            onChanged: loading
                ? null
                : (value) => context
                      .read<NotificationSettingsCubit>()
                      .setHouseholdActivity(value),
          ),
          SettingsToggleRow(
            title: LocaleKeys.weeklyImpactRecap.tr(),
            value: settings?.weeklyImpactRecap ?? false,
            onChanged: loading
                ? null
                : (value) => context
                      .read<NotificationSettingsCubit>()
                      .setWeeklyImpactRecap(value),
          ),
          const SizedBox(height: 16),
          ContextGuidanceBox(message: LocaleKeys.notificationSettingsNote.tr()),
        ],
      ),
    );
  }
}
