import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_form_select_field.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_option_bottom_sheet.dart';
import 'package:fridgy/feature/shopping/presentation/logic/fridge_intake_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/fridge_intake_state.dart';

class FridgeIntakeScreen extends StatelessWidget {
  const FridgeIntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FridgeIntakeCubit, FridgeIntakeState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == FridgeIntakeStatus.failure &&
            state.message != null) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.status == FridgeIntakeStatus.success) {
          AppSnackBar.show(
            context,
            LocaleKeys.shoppingAddedToFridge.tr(
              args: ['${state.result?.createdCount ?? 0}'],
            ),
          );
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final cubit = context.read<FridgeIntakeCubit>();
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(
                    title: LocaleKeys.shoppingReviewFridge.tr(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    LocaleKeys.shoppingReviewFridgeBody.tr(),
                    style: AppTextStyles.secondaryBodyRegular14Text,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: state.lines.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final line = state.lines[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.name,
                              style: AppTextStyles.bodySemiBold16,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${line.quantity} ${FoodItemFormatters.unitLabel(line.unit)}',
                              style: AppTextStyles.secondaryBodyRegular14Text,
                            ),
                            const SizedBox(height: 10),
                            FoodFormSelectField(
                              label: LocaleKeys.storageLabel.tr(),
                              hint: LocaleKeys.storageLabel.tr(),
                              valueText: FoodItemFormatters.storageLabel(
                                line.storage,
                              ),
                              onTap: () async {
                                final picked =
                                    await showFoodOptionBottomSheet<
                                      StorageLocation
                                    >(
                                      context: context,
                                      title: LocaleKeys.storageLabel.tr(),
                                      selected: line.storage,
                                      options: StorageLocation.values
                                          .map(
                                            (s) => FoodOptionSheetItem(
                                              label:
                                                  FoodItemFormatters.storageLabel(
                                                    s,
                                                  ),
                                              value: s,
                                            ),
                                          )
                                          .toList(),
                                    );
                                if (picked != null) {
                                  cubit.updateLine(
                                    lineId: line.id,
                                    storage: picked,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: LocaleKeys.shoppingConfirmAddToFridge.tr(),
                  onPrimaryPressed:
                      state.status == FridgeIntakeStatus.submitting
                      ? null
                      : cubit.confirm,
                  isPrimaryLoading:
                      state.status == FridgeIntakeStatus.submitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
