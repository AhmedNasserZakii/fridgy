import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/radio_choice_tile.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/setup_illustration.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';

class WorkoutStep extends StatelessWidget {
  const WorkoutStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            StepIntro(
              title: LocaleKeys.workoutTitle.tr(),
              subtitle: LocaleKeys.workoutSubtitle.tr(),
            ),
            const SizedBox(height: 24),
            const SetupIllustration(
              assetPath: AppAssets.setupWorkout,
              height: 192,
            ),
            const SizedBox(height: 24),
            Text(
              LocaleKeys.workoutQuestion.tr(),
              style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            RadioChoiceTile(
              label: LocaleKeys.workoutYes.tr(),
              emoji: '🏃',
              variant: RadioChoiceVariant.emoji,
              selected: state.worksOut == true,
              onTap: () =>
                  context.read<ProfileSetupCubit>().selectWorksOut(true),
            ),
            const SizedBox(height: 12),
            RadioChoiceTile(
              label: LocaleKeys.workoutNo.tr(),
              emoji: '🌱',
              variant: RadioChoiceVariant.emoji,
              selected: state.worksOut == false,
              onTap: () =>
                  context.read<ProfileSetupCubit>().selectWorksOut(false),
            ),
          ],
        );
      },
    );
  }
}
