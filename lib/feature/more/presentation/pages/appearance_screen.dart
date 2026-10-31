import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/logic/appearance_cubit.dart';
import 'package:fridgy/feature/more/presentation/widgets/context_guidance_box.dart';
import 'package:fridgy/feature/more/presentation/widgets/theme_option_row.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BackTitleHeader(title: LocaleKeys.appearance.tr()),
            ),
            Expanded(
              child: BlocBuilder<AppearanceCubit, ThemeMode>(
                builder: (context, mode) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      Text(
                        LocaleKeys.appearanceHeadline.tr(),
                        style: AppTextStyles.titleBold26,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.appearanceSubtitle.tr(),
                        style: AppTextStyles.bodyRegular16,
                      ),
                      const SizedBox(height: 16),
                      ThemeOptionRow(
                        title: LocaleKeys.themeLight.tr(),
                        subtitle: LocaleKeys.themeLightSubtitle.tr(),
                        selected: mode == ThemeMode.light,
                        onTap: () => context.read<AppearanceCubit>().select(
                          ThemeMode.light,
                        ),
                      ),
                      ThemeOptionRow(
                        title: LocaleKeys.themeDark.tr(),
                        subtitle: LocaleKeys.themeDarkSubtitle.tr(),
                        selected: mode == ThemeMode.dark,
                        onTap: () => context.read<AppearanceCubit>().select(
                          ThemeMode.dark,
                        ),
                      ),
                      ThemeOptionRow(
                        title: LocaleKeys.themeSystem.tr(),
                        subtitle: LocaleKeys.themeSystemSubtitle.tr(),
                        selected: mode == ThemeMode.system,
                        onTap: () => context.read<AppearanceCubit>().select(
                          ThemeMode.system,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ContextGuidanceBox(
                        message: LocaleKeys.appearanceNote.tr(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
