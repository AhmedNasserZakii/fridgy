import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/shopping/domain/params/upsert_shopping_list_item_params.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/add_list_item_state.dart';

class AddListItemCubit extends Cubit<AddListItemState> {
  AddListItemCubit({required this._shoppingRepo})
    : super(const AddListItemState());

  final ShoppingRepo _shoppingRepo;

  void nameChanged(String value) => emit(state.copyWith(name: value));

  void quantityChanged(num value) => emit(state.copyWith(quantity: value));

  void unitChanged(FoodUnit? value) =>
      emit(state.copyWith(unit: value, clearUnit: value == null));

  void categoryChanged(FoodCategory? value) =>
      emit(state.copyWith(category: value, clearCategory: value == null));

  Future<void> submit() async {
    if (isClosed || state.status == AddListItemStatus.submitting) return;
    emit(
      state.copyWith(
        status: AddListItemStatus.submitting,
        clearMessage: true,
        fieldErrors: const {},
        clearCreated: true,
      ),
    );
    final result = await _shoppingRepo.addListItem(
      UpsertShoppingListItemParams(
        name: state.name.trim(),
        quantity: state.quantity,
        unit: state.unit,
        category: state.category,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddListItemStatus.failure,
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (item) => emit(
        state.copyWith(
          status: AddListItemStatus.success,
          createdItem: item,
          clearMessage: true,
        ),
      ),
    );
  }
}
