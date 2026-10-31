import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/food_category_entity.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/food_favorite_tile.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/helper_message.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FoodFavoritesStep extends StatelessWidget {
  const FoodFavoritesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        final loading = state.optionsStatus == OptionsStatus.loading;
        final categories = loading
            ? List.generate(
                9,
                (i) => FoodCategoryEntity(
                  id: 'skeleton_$i',
                  name: 'Category name',
                  emoji: '🍲',
                ),
              )
            : (state.options?.foodCategories ?? const []);

        return Skeletonizer(
          enabled: loading,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              StepIntro(
                title: LocaleKeys.foodFavoritesTitle.tr(),
                subtitle: LocaleKeys.foodFavoritesSubtitle.tr(),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 108,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return FoodFavoriteTile(
                    category: category,
                    selected: state.favoriteFoodIds.contains(category.id),
                    onTap: loading
                        ? () {}
                        : () => context
                              .read<ProfileSetupCubit>()
                              .toggleFavoriteFood(category.id),
                  );
                },
              ),
              const SizedBox(height: 16),
              HelperMessage(message: LocaleKeys.foodFavoritesHelper.tr()),
            ],
          ),
        );
      },
    );
  }
}
