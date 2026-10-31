import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';

enum ShoppingListStatus { loading, success, empty, failure }

enum ShoppingListActionStatus { idle, working, success, failure }

class ShoppingListState extends Equatable {
  const ShoppingListState({
    this.status = ShoppingListStatus.loading,
    this.items = const [],
    this.message,
    this.actionStatus = ShoppingListActionStatus.idle,
    this.intake,
  });

  final ShoppingListStatus status;
  final List<ShoppingListItemEntity> items;
  final String? message;
  final ShoppingListActionStatus actionStatus;
  final FridgeIntakeEntity? intake;

  int get checkedCount => items.where((e) => e.isChecked).length;

  ShoppingListState copyWith({
    ShoppingListStatus? status,
    List<ShoppingListItemEntity>? items,
    String? message,
    ShoppingListActionStatus? actionStatus,
    FridgeIntakeEntity? intake,
    bool clearMessage = false,
    bool clearIntake = false,
  }) {
    return ShoppingListState(
      status: status ?? this.status,
      items: items ?? this.items,
      message: clearMessage ? null : (message ?? this.message),
      actionStatus: actionStatus ?? this.actionStatus,
      intake: clearIntake ? null : (intake ?? this.intake),
    );
  }

  @override
  List<Object?> get props => [status, items, message, actionStatus, intake];
}
