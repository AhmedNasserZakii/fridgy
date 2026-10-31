import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/constants/locale_keys.dart';

abstract class AppValidators {
  AppValidators._();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  static String? isValidName(String? name) {
    final value = name?.trim() ?? '';
    if (value.isEmpty) return LocaleKeys.thisFieldIsRequired.tr();
    if (value.length < 2) return LocaleKeys.nameMinTwo.tr();
    if (value.length > 50) return LocaleKeys.nameMaxFifty.tr();
    return null;
  }

  static String? isValidEmail(String? email) {
    final value = email?.trim() ?? '';
    if (value.isEmpty) return LocaleKeys.thisFieldIsRequired.tr();
    if (!_emailRegex.hasMatch(value)) return LocaleKeys.thisNotEmail.tr();
    return null;
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return LocaleKeys.thisFieldIsRequired.tr();
    }
    if (password.length < 8) return LocaleKeys.passwordMinEight.tr();
    return null;
  }
}
