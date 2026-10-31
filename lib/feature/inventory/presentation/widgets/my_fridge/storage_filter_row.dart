import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/filter_chip_text.dart';

class StorageFilterRow extends StatelessWidget {
  const StorageFilterRow({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final StorageLocation? selected;
  final ValueChanged<StorageLocation?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipText(
            label: LocaleKeys.storageAll.tr(),
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 12),
          FilterChipText(
            label: LocaleKeys.storageFridge.tr(),
            selected: selected == StorageLocation.fridge,
            onTap: () => onSelected(StorageLocation.fridge),
          ),
          const SizedBox(width: 12),
          FilterChipText(
            label: LocaleKeys.storageFreezer.tr(),
            selected: selected == StorageLocation.freezer,
            onTap: () => onSelected(StorageLocation.freezer),
          ),
          const SizedBox(width: 12),
          FilterChipText(
            label: LocaleKeys.storagePantry.tr(),
            selected: selected == StorageLocation.pantry,
            onTap: () => onSelected(StorageLocation.pantry),
          ),
        ],
      ),
    );
  }
}
