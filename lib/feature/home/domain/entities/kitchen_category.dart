import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';

enum KitchenCategory {
  vegetables,
  fruits,
  dairy,
  meat,
  frozen,
  pantry;

  String get labelKey {
    switch (this) {
      case KitchenCategory.vegetables:
        return LocaleKeys.categoryVegetables;
      case KitchenCategory.fruits:
        return LocaleKeys.categoryFruits;
      case KitchenCategory.dairy:
        return LocaleKeys.categoryDairy;
      case KitchenCategory.meat:
        return LocaleKeys.categoryMeat;
      case KitchenCategory.frozen:
        return LocaleKeys.categoryFrozen;
      case KitchenCategory.pantry:
        return LocaleKeys.categoryPantry;
    }
  }

  String get imageAsset {
    switch (this) {
      case KitchenCategory.vegetables:
        return AppAssets.categoryVegetables;
      case KitchenCategory.fruits:
        return AppAssets.categoryFruits;
      case KitchenCategory.dairy:
        return AppAssets.categoryDairy;
      case KitchenCategory.meat:
        return AppAssets.categoryMeat;
      case KitchenCategory.frozen:
        return AppAssets.categoryFrozen;
      case KitchenCategory.pantry:
        return AppAssets.categoryPantry;
    }
  }
}
