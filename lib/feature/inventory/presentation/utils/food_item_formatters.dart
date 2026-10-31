import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

abstract class FoodItemFormatters {
  static String quantityLabel(FoodItemEntity item) {
    final qty = item.quantity;
    final qtyText = qty == qty.roundToDouble() || qty is int
        ? qty.round().toString()
        : qty.toString();
    final unit = _unitLabel(item.unit);
    return unit.isEmpty ? qtyText : '$qtyText $unit';
  }

  static String categoryLabel(FoodCategory? category) {
    switch (category) {
      case FoodCategory.vegetables:
        return LocaleKeys.categoryVegetables.tr();
      case FoodCategory.fruits:
        return LocaleKeys.categoryFruits.tr();
      case FoodCategory.dairy:
        return LocaleKeys.categoryDairy.tr();
      case FoodCategory.meat:
        return LocaleKeys.categoryMeat.tr();
      case FoodCategory.bakery:
        return LocaleKeys.categoryBakery.tr();
      case FoodCategory.other:
        return LocaleKeys.categoryOther.tr();
      case null:
        return '';
    }
  }

  static String storageLabel(StorageLocation? storage) {
    switch (storage) {
      case StorageLocation.fridge:
        return LocaleKeys.storageFridge.tr();
      case StorageLocation.freezer:
        return LocaleKeys.storageFreezer.tr();
      case StorageLocation.pantry:
        return LocaleKeys.storagePantry.tr();
      case null:
        return '';
    }
  }

  static String subtitle(FoodItemEntity item) {
    final parts = <String>[
      quantityLabel(item),
      if (storageLabel(item.storage).isNotEmpty) storageLabel(item.storage),
      if (item.isPartlyUsed) LocaleKeys.partlyUsed.tr(),
    ];
    return parts.join(' · ');
  }

  static String? expiryLine(FoodItemEntity item) {
    if (item.expiryDate == null || item.expiryStatus == null) return null;
    final date = DateFormat('d MMM yyyy').format(item.expiryDate!);
    switch (item.expiryStatus!) {
      case ExpiryStatus.useSoon:
        final days = item.daysLeft ?? 0;
        final daysText = days == 1
            ? LocaleKeys.day.tr(args: ['1'])
            : LocaleKeys.days.tr(args: ['$days']);
        return LocaleKeys.useSoonLine.tr(args: [date, daysText]);
      case ExpiryStatus.expired:
        return LocaleKeys.expiredLine.tr(args: [date]);
      case ExpiryStatus.fresh:
        return date;
    }
  }

  static String unitLabel(FoodUnit? unit) => _unitLabel(unit);

  static String _unitLabel(FoodUnit? unit) {
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
}
