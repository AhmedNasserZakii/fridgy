import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/household_size.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/number_choice_chip.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/setup_illustration.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';

class KitchenStep extends StatelessWidget {
  const KitchenStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            StepIntro(
              title: LocaleKeys.kitchenTitle.tr(),
              subtitle: LocaleKeys.kitchenSubtitle.tr(),
            ),
            const SizedBox(height: 24),
            const SetupIllustration(assetPath: AppAssets.setupKitchen),
            const SizedBox(height: 24),
            Text(
              LocaleKeys.kitchenQuestion.tr(),
              style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                for (var i = 0; i < HouseholdSize.values.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  NumberChoiceChip(
                    label: HouseholdSize.values[i] == HouseholdSize.fivePlus
                        ? LocaleKeys.householdFivePlus.tr()
                        : HouseholdSize.values[i].label,
                    selected: state.householdSize == HouseholdSize.values[i],
                    onTap: () => context
                        .read<ProfileSetupCubit>()
                        .selectHouseholdSize(HouseholdSize.values[i]),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
