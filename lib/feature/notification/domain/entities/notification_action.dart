import 'package:equatable/equatable.dart';
import 'package:fridgy/core/helper/print_debug.dart';

enum NotificationActionType {
  foodItem,
  shoppingList,
  mealPlan;

  static NotificationActionType? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'food_item':
        return NotificationActionType.foodItem;
      case 'shopping_list':
        return NotificationActionType.shoppingList;
      case 'meal_plan':
        return NotificationActionType.mealPlan;
      default:
        printDebug(message: 'Unknown NotificationActionType: $value');
        return null;
    }
  }
}

class NotificationAction extends Equatable {
  const NotificationAction({required this.type, required this.id});

  final NotificationActionType type;
  final String id;

  @override
  List<Object?> get props => [type, id];
}
