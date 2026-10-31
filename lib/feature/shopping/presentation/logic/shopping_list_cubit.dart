import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit({required this._shoppingRepo})
    : super(const ShoppingListState()) {
    load();
  }

  final ShoppingRepo _shoppingRepo;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: ShoppingListStatus.loading,
        clearMessage: true,
        clearIntake: true,
        actionStatus: ShoppingListActionStatus.idle,
      ),
    );
    final result = await _shoppingRepo.getList();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ShoppingListStatus.failure,
          message: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: items.isEmpty
              ? ShoppingListStatus.empty
              : ShoppingListStatus.success,
          items: items,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> toggle(String id) async {
    if (isClosed || state.actionStatus == ShoppingListActionStatus.working) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: ShoppingListActionStatus.working,
        clearMessage: true,
      ),
    );
    final result = await _shoppingRepo.toggleListItem(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ShoppingListActionStatus.failure,
          message: failure.message,
        ),
      ),
      (updated) {
        final next = state.items
            .map((item) => item.id == updated.id ? updated : item)
            .toList();
        emit(
          state.copyWith(
            items: next,
            status: next.isEmpty
                ? ShoppingListStatus.empty
                : ShoppingListStatus.success,
            actionStatus: ShoppingListActionStatus.idle,
          ),
        );
      },
    );
  }

  Future<void> delete(String id) async {
    if (isClosed || state.actionStatus == ShoppingListActionStatus.working) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: ShoppingListActionStatus.working,
        clearMessage: true,
      ),
    );
    final result = await _shoppingRepo.deleteListItem(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ShoppingListActionStatus.failure,
          message: failure.message,
        ),
      ),
      (_) {
        final next = state.items.where((item) => item.id != id).toList();
        emit(
          state.copyWith(
            items: next,
            status: next.isEmpty
                ? ShoppingListStatus.empty
                : ShoppingListStatus.success,
            actionStatus: ShoppingListActionStatus.idle,
          ),
        );
      },
    );
  }

  Future<void> completePurchase() async {
    if (isClosed || state.actionStatus == ShoppingListActionStatus.working) {
      return;
    }
    if (state.checkedCount == 0) return;

    emit(
      state.copyWith(
        actionStatus: ShoppingListActionStatus.working,
        clearMessage: true,
        clearIntake: true,
      ),
    );
    final result = await _shoppingRepo.completeList();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ShoppingListActionStatus.failure,
          message: failure.message,
        ),
      ),
      (intake) => emit(
        state.copyWith(
          actionStatus: ShoppingListActionStatus.success,
          intake: intake,
        ),
      ),
    );
  }

  void clearAction() {
    if (isClosed) return;
    emit(
      state.copyWith(
        actionStatus: ShoppingListActionStatus.idle,
        clearIntake: true,
        clearMessage: true,
      ),
    );
  }
}
