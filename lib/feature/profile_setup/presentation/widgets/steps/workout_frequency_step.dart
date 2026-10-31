import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/workout_frequency.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/helper_message.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/radio_choice_tile.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';

class WorkoutFrequencyStep extends StatelessWidget {
  const WorkoutFrequencyStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            StepIntro(
              title: LocaleKeys.workoutFrequencyTitle.tr(),
              subtitle: LocaleKeys.workoutFrequencySubtitle.tr(),
            ),
            const SizedBox(height: 24),
            for (final frequency in WorkoutFrequency.values) ...[
              RadioChoiceTile(
                label: frequency.labelKey.tr(),
                subtitle: frequency.subtitleKey.tr(),
                iconAsset: frequency.iconAsset,
                variant: RadioChoiceVariant.iconSubtitle,
                selected: state.workoutFrequency == frequency,
                onTap: () => context
                    .read<ProfileSetupCubit>()
                    .selectWorkoutFrequency(frequency),
              ),
              const SizedBox(height: 12),
            ],
            HelperMessage(message: LocaleKeys.workoutFrequencyHelper.tr()),
          ],
        );
      },
    );
  }
}
