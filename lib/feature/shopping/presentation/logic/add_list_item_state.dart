import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';

enum AddListItemStatus { editing, submitting, success, failure }

class AddListItemState extends Equatable {
  const AddListItemState({
    this.status = AddListItemStatus.editing,
    this.name = '',
    this.quantity = 1,
    this.unit = FoodUnit.pcs,
    this.category,
    this.message,
    this.fieldErrors = const {},
    this.createdItem,
  });

  final AddListItemStatus status;
  final String name;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final String? message;
  final Map<String, List<String>> fieldErrors;
  final ShoppingListItemEntity? createdItem;

  AddListItemState copyWith({
    AddListItemStatus? status,
    String? name,
    num? quantity,
    FoodUnit? unit,
    FoodCategory? category,
    String? message,
    Map<String, List<String>>? fieldErrors,
    ShoppingListItemEntity? createdItem,
    bool clearMessage = false,
    bool clearCategory = false,
    bool clearUnit = false,
    bool clearCreated = false,
  }) {
    return AddListItemState(
      status: status ?? this.status,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: clearUnit ? null : (unit ?? this.unit),
      category: clearCategory ? null : (category ?? this.category),
      message: clearMessage ? null : (message ?? this.message),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      createdItem: clearCreated ? null : (createdItem ?? this.createdItem),
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    quantity,
    unit,
    category,
    message,
    fieldErrors,
    createdItem,
  ];
}
