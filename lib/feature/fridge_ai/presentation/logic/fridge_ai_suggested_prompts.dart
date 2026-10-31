import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

/// Static suggested prompts from Figma — never from the API.
abstract class FridgeAiSuggestedPrompts {
  static List<String> forMode(FridgeAiMode mode) {
    switch (mode) {
      case FridgeAiMode.addFood:
        return [
          LocaleKeys.fridgeAiPromptAdd1.tr(),
          LocaleKeys.fridgeAiPromptAdd2.tr(),
          LocaleKeys.fridgeAiPromptAdd3.tr(),
        ];
      case FridgeAiMode.useFood:
        return [
          LocaleKeys.fridgeAiPromptUse1.tr(),
          LocaleKeys.fridgeAiPromptUse2.tr(),
          LocaleKeys.fridgeAiPromptUse3.tr(),
        ];
    }
  }

  static String heading(FridgeAiMode mode) {
    switch (mode) {
      case FridgeAiMode.addFood:
        return LocaleKeys.fridgeAiAddHeading.tr();
      case FridgeAiMode.useFood:
        return LocaleKeys.fridgeAiUseHeading.tr();
    }
  }

  static String body(FridgeAiMode mode) {
    switch (mode) {
      case FridgeAiMode.addFood:
        return LocaleKeys.fridgeAiAddBody.tr();
      case FridgeAiMode.useFood:
        return LocaleKeys.fridgeAiUseBody.tr();
    }
  }
}
