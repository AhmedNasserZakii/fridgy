import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/domain/params/upsert_food_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_form_state.dart';

class FoodFormCubit extends Cubit<FoodFormState> {
  FoodFormCubit({required this._inventoryRepo}) : super(const FoodFormState());

  final InventoryRepo _inventoryRepo;

  void init({String? itemId}) {
    if (itemId == null) {
      emit(state.copyWith(itemId: null, loadStatus: FoodFormLoadStatus.loaded));
      return;
    }
    emit(
      state.copyWith(itemId: itemId, loadStatus: FoodFormLoadStatus.loading),
    );
    _loadItem(itemId);
  }

  Future<void> _loadItem(String id) async {
    final result = await _inventoryRepo.getById(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadStatus: FoodFormLoadStatus.failure,
          message: failure.message,
        ),
      ),
      (item) => emit(
        state.copyWith(
          loadStatus: FoodFormLoadStatus.loaded,
          name: item.name,
          category: item.category,
          quantity: item.quantity,
          unit: item.unit,
          storage: item.storage,
          purchaseDate: item.purchaseDate,
          expiryDate: item.expiryDate,
          imageUrl: item.imageUrl,
          isPartlyUsed: item.isPartlyUsed,
          clearMessage: true,
          fieldErrors: const {},
        ),
      ),
    );
  }

  void nameChanged(String value) => emit(state.copyWith(name: value));

  void categoryChanged(FoodCategory? value) =>
      emit(state.copyWith(category: value, clearCategory: value == null));

  void quantityChanged(num value) => emit(state.copyWith(quantity: value));

  void unitChanged(FoodUnit? value) =>
      emit(state.copyWith(unit: value, clearUnit: value == null));

  void storageChanged(StorageLocation? value) =>
      emit(state.copyWith(storage: value, clearStorage: value == null));

  void purchaseDateChanged(DateTime? value) => emit(
    state.copyWith(purchaseDate: value, clearPurchaseDate: value == null),
  );

  void expiryDateChanged(DateTime? value) =>
      emit(state.copyWith(expiryDate: value, clearExpiryDate: value == null));

  Future<void> submit() async {
    if (isClosed || state.isSubmitting) return;

    emit(
      state.copyWith(
        submitStatus: FoodFormSubmitStatus.submitting,
        clearMessage: true,
        fieldErrors: const {},
        clearSubmittedItem: true,
      ),
    );

    final params = UpsertFoodParams(
      name: state.name.trim(),
      category: state.category,
      quantity: state.quantity,
      unit: state.unit,
      storage: state.storage,
      purchaseDate: state.purchaseDate,
      expiryDate: state.expiryDate,
      imageUrl: state.imageUrl,
      isPartlyUsed: state.isPartlyUsed,
    );

    final result = state.isEdit
        ? await _inventoryRepo.update(state.itemId!, params)
        : await _inventoryRepo.create(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: FoodFormSubmitStatus.failure,
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (item) => emit(
        state.copyWith(
          submitStatus: FoodFormSubmitStatus.success,
          submittedItem: item,
        ),
      ),
    );
  }

  String? nameFieldError() => state.fieldError(ApiKeys.name);

  String? categoryFieldError() => state.fieldError(ApiKeys.category);

  String? quantityFieldError() => state.fieldError(ApiKeys.quantity);
}
