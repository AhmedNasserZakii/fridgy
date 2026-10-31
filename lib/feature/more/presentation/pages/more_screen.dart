import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/more/presentation/logic/more_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/more_state.dart';
import 'package:fridgy/feature/more/presentation/widgets/more_profile_header.dart';
import 'package:fridgy/feature/more/presentation/widgets/settings_list_row.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreCubit, MoreState>(
      listenWhen: (previous, current) =>
          previous.signedOut != current.signedOut && current.signedOut,
      listener: (context, state) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.signIn, (_) => false);
      },
      builder: (context, state) {
        final user = state.user;
        final name = user?.name ?? '';
        final email = user?.email ?? '';

        return ColoredBox(
          color: AppColors.surfaceDefault,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MoreProfileHeader(
                name: name.isEmpty ? '—' : name,
                email: email.isEmpty ? '—' : email,
                onTap: () async {
                  await Navigator.of(context).pushNamed(AppRoute.editProfile);
                  if (context.mounted) {
                    context.read<MoreCubit>().refreshUser();
                  }
                },
              ),
              const SizedBox(height: 16),
              SettingsListRow(
                iconAsset: AppAssets.icBookmark,
                title: LocaleKeys.savedRecipes.tr(),
                subtitle: LocaleKeys.savedRecipesCount.tr(args: ['3']),
                onTap: () =>
                    AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.makeFridgyYours.tr(),
                style: AppTextStyles.titleBold20,
              ),
              const SizedBox(height: 8),
              SettingsListRow(
                iconAsset: AppAssets.icSlidersHorizontal,
                title: LocaleKeys.foodPreferences.tr(),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoute.profileSetupEdit),
              ),
              SettingsListRow(
                iconAsset: AppAssets.icBell,
                title: LocaleKeys.notificationSettings.tr(),
                onTap: () =>
                    Navigator.of(context)
                        .pushNamed(AppRoute.notificationSettings),
              ),
              SettingsListRow(
                iconAsset: AppAssets.icSunMoon,
                title: LocaleKeys.appearance.tr(),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoute.appearance),
              ),
              SettingsListRow(
                iconAsset: AppAssets.icRuler,
                title: LocaleKeys.unitsAndMeasurements.tr(),
                onTap: () => Navigator.of(context).pushNamed(AppRoute.units),
              ),
              SettingsListRow(
                iconAsset: AppAssets.icShieldCheck,
                title: LocaleKeys.privacyAndData.tr(),
                onTap: () => Navigator.of(context).pushNamed(AppRoute.privacy),
              ),
              SettingsListRow(
                iconAsset: AppAssets.icCircleHelp,
                title: LocaleKeys.helpAndSupport.tr(),
                onTap: () => Navigator.of(context).pushNamed(AppRoute.help),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: state.isSigningOut
                    ? null
                    : () => context.read<MoreCubit>().signOut(),
                child: state.isSigningOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        LocaleKeys.signOut.tr(),
                        style: AppTextStyles.bodySemiBold16Brand,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.fridgyTagline.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.captionRegular12,
              ),
            ],
          ),
        );
      },
    );
  }
}
