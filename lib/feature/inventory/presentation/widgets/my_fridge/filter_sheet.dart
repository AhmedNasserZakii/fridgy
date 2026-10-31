import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_sort.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_status_filter.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_state.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/filter_chip_text.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/sort_chip.dart';

enum _ExpiryFilterOption { any, within3, within7, expired }

Future<void> showMyFridgeFilterSheet({
  required BuildContext context,
  required MyFridgeCubit cubit,
  required MyFridgeState state,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _MyFridgeFilterSheet(cubit: cubit, state: state),
  );
}

class _MyFridgeFilterSheet extends StatefulWidget {
  const _MyFridgeFilterSheet({required this.cubit, required this.state});

  final MyFridgeCubit cubit;
  final MyFridgeState state;

  @override
  State<_MyFridgeFilterSheet> createState() => _MyFridgeFilterSheetState();
}

class _MyFridgeFilterSheetState extends State<_MyFridgeFilterSheet> {
  late StorageLocation? _storage;
  late FoodCategory? _category;
  late _ExpiryFilterOption _expiry;
  late InventorySort _sort;

  @override
  void initState() {
    super.initState();
    _storage = widget.state.storage;
    _category = widget.state.category;
    _sort = widget.state.sort;
    _expiry = _expiryFromState(widget.state);
  }

  _ExpiryFilterOption _expiryFromState(MyFridgeState state) {
    if (state.statusFilter == InventoryStatusFilter.expired) {
      return _ExpiryFilterOption.expired;
    }
    if (state.expiresWithinDays == 3) return _ExpiryFilterOption.within3;
    if (state.expiresWithinDays == 7) return _ExpiryFilterOption.within7;
    return _ExpiryFilterOption.any;
  }

  Future<void> _onReset() async {
    Navigator.of(context).pop();
    await widget.cubit.resetFilters();
  }

  Future<void> _onApply() async {
    var clearStatusFilter = false;
    var clearExpiresWithinDays = false;
    InventoryStatusFilter? statusFilter;
    int? expiresWithinDays;

    switch (_expiry) {
      case _ExpiryFilterOption.any:
        clearStatusFilter = true;
        clearExpiresWithinDays = true;
      case _ExpiryFilterOption.within3:
        expiresWithinDays = 3;
        clearStatusFilter = true;
      case _ExpiryFilterOption.within7:
        expiresWithinDays = 7;
        clearStatusFilter = true;
      case _ExpiryFilterOption.expired:
        statusFilter = InventoryStatusFilter.expired;
        clearExpiresWithinDays = true;
    }

    Navigator.of(context).pop();
    await widget.cubit.applySheetFilters(
      storage: _storage,
      category: _category,
      statusFilter: statusFilter,
      expiresWithinDays: expiresWithinDays,
      sort: _sort,
      clearStorage: _storage == null,
      clearCategory: _category == null,
      clearStatusFilter: clearStatusFilter,
      clearExpiresWithinDays: clearExpiresWithinDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final total = widget.state.meta?.total;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDefault,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.filterYourFood.tr(),
                  style: AppTextStyles.titleBold20,
                ),
              ),
              TextButton(
                onPressed: _onReset,
                child: Text(
                  LocaleKeys.resetFilters.tr(),
                  style: AppTextStyles.bodySemiBold16Brand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(LocaleKeys.filterStorage.tr()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilterChipText(
                label: LocaleKeys.storageAll.tr(),
                selected: _storage == null,
                onTap: () => setState(() => _storage = null),
              ),
              FilterChipText(
                label: LocaleKeys.storageFridge.tr(),
                selected: _storage == StorageLocation.fridge,
                onTap: () => setState(() => _storage = StorageLocation.fridge),
              ),
              FilterChipText(
                label: LocaleKeys.storageFreezer.tr(),
                selected: _storage == StorageLocation.freezer,
                onTap: () => setState(() => _storage = StorageLocation.freezer),
              ),
              FilterChipText(
                label: LocaleKeys.storagePantry.tr(),
                selected: _storage == StorageLocation.pantry,
                onTap: () => setState(() => _storage = StorageLocation.pantry),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(LocaleKeys.filterCategory.tr()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilterChipText(
                label: LocaleKeys.categoryAllFood.tr(),
                selected: _category == null,
                onTap: () => setState(() => _category = null),
              ),
              for (final category in FoodCategory.values)
                FilterChipText(
                  label: FoodItemFormatters.categoryLabel(category),
                  selected: _category == category,
                  onTap: () => setState(() => _category = category),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(LocaleKeys.filterExpiry.tr()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilterChipText(
                label: LocaleKeys.expiryAnyDate.tr(),
                selected: _expiry == _ExpiryFilterOption.any,
                onTap: () => setState(() => _expiry = _ExpiryFilterOption.any),
              ),
              FilterChipText(
                label: LocaleKeys.expiryWithin3Days.tr(),
                selected: _expiry == _ExpiryFilterOption.within3,
                onTap: () =>
                    setState(() => _expiry = _ExpiryFilterOption.within3),
              ),
              FilterChipText(
                label: LocaleKeys.expiryWithin7Days.tr(),
                selected: _expiry == _ExpiryFilterOption.within7,
                onTap: () =>
                    setState(() => _expiry = _ExpiryFilterOption.within7),
              ),
              FilterChipText(
                label: LocaleKeys.expiryExpired.tr(),
                selected: _expiry == _ExpiryFilterOption.expired,
                onTap: () =>
                    setState(() => _expiry = _ExpiryFilterOption.expired),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(LocaleKeys.filterSortBy.tr()),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SortChip(label: LocaleKeys.sortSoonestExpiry.tr()),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: total != null
                ? LocaleKeys.applyFiltersCount.tr(args: ['$total'])
                : LocaleKeys.applyFilters.tr(),
            onPressed: _onApply,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.bodySemiBold16Primary);
  }
}
