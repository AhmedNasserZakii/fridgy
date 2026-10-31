import 'package:fridgy/core/helper/print_debug.dart';

enum ExpiryStatus {
  expired,
  useSoon,
  fresh;

  static ExpiryStatus? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'expired':
        return ExpiryStatus.expired;
      case 'use_soon':
        return ExpiryStatus.useSoon;
      case 'fresh':
        return ExpiryStatus.fresh;
      default:
        printDebug(message: 'Unknown ExpiryStatus: $value');
        return null;
    }
  }

  String get apiValue {
    switch (this) {
      case ExpiryStatus.expired:
        return 'expired';
      case ExpiryStatus.useSoon:
        return 'use_soon';
      case ExpiryStatus.fresh:
        return 'fresh';
    }
  }
}
