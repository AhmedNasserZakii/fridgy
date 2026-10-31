import 'package:fridgy/core/helper/print_debug.dart';

enum FridgeIntakeSource {
  list,
  order;

  static FridgeIntakeSource? fromJson(String? value) {
    if (value == null) return null;
    for (final source in FridgeIntakeSource.values) {
      if (source.name == value) return source;
    }
    printDebug(message: 'Unknown FridgeIntakeSource: $value');
    return null;
  }

  String toJson() => name;
}
