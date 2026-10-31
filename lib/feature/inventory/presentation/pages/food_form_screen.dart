import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/app_text_field.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_form_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_form_state.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_form_date_field.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_form_select_field.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_option_bottom_sheet.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/guidance_box.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/photo_field_row.dart';

class FoodFormScreen extends StatefulWidget {
  const FoodFormScreen({super.key, this.itemId});

  final String? itemId;

  @override
  State<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  bool _populatedFromLoad = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.itemId != null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodFormCubit, FoodFormState>(
      listenWhen: (prev, curr) =>
          prev.submitStatus != curr.submitStatus ||
          prev.loadStatus != curr.loadStatus,
      listener: (context, state) {
        if (state.submitStatus == FoodFormSubmitStatus.success) {
          Navigator.of(context).pop(true);
          return;
        }
        if (state.submitStatus == FoodFormSubmitStatus.failure &&
            state.message != null &&
            state.fieldErrors.isEmpty) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.loadStatus == FoodFormLoadStatus.loaded &&
            _isEdit &&
            !_populatedFromLoad) {
          _populatedFromLoad = true;
          _nameController.text = state.name;
          _quantityController.text = _formatQuantity(state.quantity);
        }
      },
      builder: (context, state) {
        if (_isEdit && state.loadStatus == FoodFormLoadStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.surfaceDefault,
            body: SafeArea(
              child: InlineErrorView(
                message: state.message ?? LocaleKeys.inventoryLoadFailed.tr(),
                onRetry: () => context.read<FoodFormCubit>().init(
                      itemId: widget.itemId,
                    ),
              ),
            ),
          );
        }

        if (state.isInitialLoading) {
          return const Scaffold(
            backgroundColor: AppColors.surfaceDefault,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cubit = context.read<FoodFormCubit>();
        final title = _isEdit
            ? LocaleKeys.editFoodTitle.tr()
            : LocaleKeys.addManuallyTitle.tr();
        final saveLabel =
            _isEdit ? LocaleKeys.saveChanges.tr() : LocaleKeys.saveFood.tr();

        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                  ),
                  child: BackTitleHeader(title: title),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      8,
                      20,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          label: LocaleKeys.foodName.tr(),
                          hint: LocaleKeys.foodNameHint.tr(),
                          controller: _nameController,
                          errorText: cubit.nameFieldError(),
                          onChanged: cubit.nameChanged,
                        ),
                        const SizedBox(height: 16),
                        FoodFormSelectField(
                          label: LocaleKeys.foodCategoryLabel.tr(),
                          hint: LocaleKeys.foodCategoryLabel.tr(),
                          valueText: FoodItemFormatters.categoryLabel(
                            state.category,
                          ),
                          errorText: cubit.categoryFieldError(),
                          onTap: () => _pickCategory(context, state, cubit),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppTextField(
                                label: LocaleKeys.quantityLabel.tr(),
                                hint: '1',
                                controller: _quantityController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                errorText: cubit.quantityFieldError(),
                                onChanged: (value) {
                                  final parsed = num.tryParse(value.trim());
                                  if (parsed != null) {
                                    cubit.quantityChanged(parsed);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: FoodFormSelectField(
                                label: LocaleKeys.unitLabel.tr(),
                                hint: LocaleKeys.unitLabel.tr(),
                                valueText: _unitLabel(state.unit),
                                onTap: () => _pickUnit(context, state, cubit),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FoodFormSelectField(
                          label: LocaleKeys.storageLabel.tr(),
                          hint: LocaleKeys.storageLabel.tr(),
                          valueText: FoodItemFormatters.storageLabel(
                            state.storage,
                          ),
                          onTap: () => _pickStorage(context, state, cubit),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            FoodFormDateField(
                              label: LocaleKeys.purchaseDate.tr(),
                              date: state.purchaseDate,
                              onTap: () => _pickDate(
                                context,
                                initial: state.purchaseDate,
                                onPicked: cubit.purchaseDateChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            FoodFormDateField(
                              label: LocaleKeys.expirationDate.tr(),
                              date: state.expiryDate,
                              onTap: () => _pickDate(
                                context,
                                initial: state.expiryDate,
                                onPicked: cubit.expiryDateChanged,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        PhotoFieldRow(
                          onTap: () => AppSnackBar.show(
                            context,
                            LocaleKeys.comingSoon.tr(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GuidanceBox(text: LocaleKeys.foodFormGuidance.tr()),
                      ],
                    ),
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: saveLabel,
                  isPrimaryLoading: state.isSubmitting,
                  onPrimaryPressed: state.isSubmitting ? null : cubit.submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatQuantity(num value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toString();
  }

  String _unitLabel(FoodUnit? unit) {
    switch (unit) {
      case FoodUnit.g:
        return LocaleKeys.unitG.tr();
      case FoodUnit.kg:
        return LocaleKeys.unitKg.tr();
      case FoodUnit.ml:
        return LocaleKeys.unitMl.tr();
      case FoodUnit.l:
        return LocaleKeys.unitL.tr();
      case FoodUnit.pcs:
        return LocaleKeys.unitPcs.tr();
      case null:
        return '';
    }
  }

  Future<void> _pickCategory(
    BuildContext context,
    FoodFormState state,
    FoodFormCubit cubit,
  ) async {
    final picked = await showFoodOptionBottomSheet<FoodCategory>(
      context: context,
      title: LocaleKeys.foodCategoryLabel.tr(),
      selected: state.category,
      options: FoodCategory.values
          .map(
            (c) => FoodOptionSheetItem(
              label: FoodItemFormatters.categoryLabel(c),
              value: c,
            ),
          )
          .toList(),
    );
    if (picked != null) cubit.categoryChanged(picked);
  }

  Future<void> _pickUnit(
    BuildContext context,
    FoodFormState state,
    FoodFormCubit cubit,
  ) async {
    final picked = await showFoodOptionBottomSheet<FoodUnit>(
      context: context,
      title: LocaleKeys.unitLabel.tr(),
      selected: state.unit,
      options: FoodUnit.values
          .map((u) => FoodOptionSheetItem(label: _unitLabel(u), value: u))
          .toList(),
    );
    if (picked != null) cubit.unitChanged(picked);
  }

  Future<void> _pickStorage(
    BuildContext context,
    FoodFormState state,
    FoodFormCubit cubit,
  ) async {
    final picked = await showFoodOptionBottomSheet<StorageLocation>(
      context: context,
      title: LocaleKeys.storageLabel.tr(),
      selected: state.storage,
      options: StorageLocation.values
          .map(
            (s) => FoodOptionSheetItem(
              label: FoodItemFormatters.storageLabel(s),
              value: s,
            ),
          )
          .toList(),
    );
    if (picked != null) cubit.storageChanged(picked);
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime? initial,
    required ValueChanged<DateTime?> onPicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) onPicked(picked);
  }
}
