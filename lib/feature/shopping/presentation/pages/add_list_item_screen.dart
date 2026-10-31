import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/app_text_field.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_form_select_field.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_option_bottom_sheet.dart';
import 'package:fridgy/feature/shopping/presentation/logic/add_list_item_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/add_list_item_state.dart';

class AddListItemScreen extends StatefulWidget {
  const AddListItemScreen({super.key});

  @override
  State<AddListItemScreen> createState() => _AddListItemScreenState();
}

class _AddListItemScreenState extends State<AddListItemScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddListItemCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _quantityController = TextEditingController(text: '${state.quantity}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddListItemCubit, AddListItemState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddListItemStatus.failure &&
            state.message != null) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.status == AddListItemStatus.success) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddListItemCubit>();
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(
                    title: LocaleKeys.shoppingAddItem.tr(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      AppTextField(
                        label: LocaleKeys.foodName.tr(),
                        hint: LocaleKeys.foodNameHint.tr(),
                        controller: _nameController,
                        errorText: state.fieldErrors['name']?.first,
                        onChanged: cubit.nameChanged,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: LocaleKeys.quantityLabel.tr(),
                        hint: '1',
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: state.fieldErrors['quantity']?.first,
                        onChanged: (value) {
                          final parsed = num.tryParse(value.trim());
                          if (parsed != null) cubit.quantityChanged(parsed);
                        },
                      ),
                      const SizedBox(height: 16),
                      FoodFormSelectField(
                        label: LocaleKeys.unitLabel.tr(),
                        hint: LocaleKeys.unitLabel.tr(),
                        valueText: FoodItemFormatters.unitLabel(state.unit),
                        onTap: () async {
                          final picked =
                              await showFoodOptionBottomSheet<FoodUnit>(
                                context: context,
                                title: LocaleKeys.unitLabel.tr(),
                                selected: state.unit,
                                options: FoodUnit.values
                                    .map(
                                      (u) => FoodOptionSheetItem(
                                        label: FoodItemFormatters.unitLabel(u),
                                        value: u,
                                      ),
                                    )
                                    .toList(),
                              );
                          if (picked != null) cubit.unitChanged(picked);
                        },
                      ),
                      const SizedBox(height: 16),
                      FoodFormSelectField(
                        label: LocaleKeys.foodCategoryLabel.tr(),
                        hint: LocaleKeys.foodCategoryLabel.tr(),
                        valueText: FoodItemFormatters.categoryLabel(
                          state.category,
                        ),
                        onTap: () async {
                          final picked =
                              await showFoodOptionBottomSheet<FoodCategory>(
                                context: context,
                                title: LocaleKeys.foodCategoryLabel.tr(),
                                selected: state.category,
                                options: FoodCategory.values
                                    .map(
                                      (c) => FoodOptionSheetItem(
                                        label: FoodItemFormatters.categoryLabel(
                                          c,
                                        ),
                                        value: c,
                                      ),
                                    )
                                    .toList(),
                              );
                          if (picked != null) cubit.categoryChanged(picked);
                        },
                      ),
                    ],
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: LocaleKeys.shoppingAddItem.tr(),
                  onPrimaryPressed: state.status == AddListItemStatus.submitting
                      ? null
                      : cubit.submit,
                  isPrimaryLoading:
                      state.status == AddListItemStatus.submitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
