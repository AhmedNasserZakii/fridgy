import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit({required this._inventoryRepo})
    : super(const FoodDetailState());

  final InventoryRepo _inventoryRepo;

  Future<void> load(String id) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: FoodDetailStatus.loading,
        clearMessage: true,
        consumeSucceeded: false,
      ),
    );

    final result = await _inventoryRepo.getById(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FoodDetailStatus.failure,
          message: failure.message,
        ),
      ),
      (item) =>
          emit(state.copyWith(status: FoodDetailStatus.success, item: item)),
    );
  }

  Future<void> consume() async {
    final id = state.item?.id;
    if (id == null || state.consumeLoading) return;

    emit(state.copyWith(consumeLoading: true, clearMessage: true));

    final result = await _inventoryRepo.consume(id);
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(consumeLoading: false, message: failure.message)),
      (_) =>
          emit(state.copyWith(consumeLoading: false, consumeSucceeded: true)),
    );
  }
}
