import 'package:fridgy/core/helper/print_debug.dart';

enum StorageLocation {
  fridge,
  freezer,
  pantry;

  static StorageLocation? fromJson(String? value) {
    if (value == null) return null;
    for (final location in StorageLocation.values) {
      if (location.name == value) return location;
    }
    printDebug(message: 'Unknown StorageLocation: $value');
    return null;
  }
}
