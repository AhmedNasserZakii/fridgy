import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/option_entity.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/ingredients_dropdown.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/radio_choice_tile.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DietStep extends StatelessWidget {
  const DietStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        final loading = state.optionsStatus == OptionsStatus.loading;
        final diets = loading
            ? List.generate(
                6,
                (i) => OptionEntity(id: 'd_$i', name: 'Diet option'),
              )
            : (state.options?.diets ?? const []);
        final ingredients = state.options?.avoidIngredients ?? const [];

        return Skeletonizer(
          enabled: loading,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              StepIntro(
                title: LocaleKeys.dietTitle.tr(),
                subtitle: LocaleKeys.dietSubtitle.tr(),
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.dietQuestion.tr(),
                style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: diets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 56,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final diet = diets[index];
                  return RadioChoiceTile(
                    label: diet.name,
                    selected: state.dietId == diet.id,
                    onTap: loading
                        ? () {}
                        : () => context.read<ProfileSetupCubit>().selectDiet(
                            diet.id,
                          ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.avoidIngredientsQuestion.tr(),
                style: AppTextStyles.secondaryBodySemiBold14.copyWith(
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              IngredientsDropdown(
                options: ingredients,
                selectedIds: state.avoidIngredientIds,
                onChanged: context
                    .read<ProfileSetupCubit>()
                    .setAvoidIngredients,
              ),
            ],
          ),
        );
      },
    );
  }
}
