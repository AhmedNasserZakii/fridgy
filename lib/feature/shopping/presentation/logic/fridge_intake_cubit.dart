import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/params/confirm_fridge_intake_params.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/fridge_intake_state.dart';

class FridgeIntakeCubit extends Cubit<FridgeIntakeState> {
  FridgeIntakeCubit({
    required this._shoppingRepo,
    required FridgeIntakeEntity intake,
  }) : super(FridgeIntakeState(intake: intake));

  final ShoppingRepo _shoppingRepo;

  void updateLine({
    required String lineId,
    String? name,
    num? quantity,
    FoodUnit? unit,
    FoodCategory? category,
    StorageLocation? storage,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
  }) {
    final lines = state.lines.map((line) {
      if (line.id != lineId) return line;
      return line.copyWith(
        name: name,
        quantity: quantity,
        unit: unit,
        category: category,
        storage: storage,
        purchaseDate: purchaseDate,
        expiryDate: expiryDate,
        clearExpiryDate: clearExpiryDate,
      );
    }).toList();
    emit(state.copyWith(intake: state.intake.copyWith(lines: lines)));
  }

  Future<void> confirm() async {
    if (isClosed || state.status == FridgeIntakeStatus.submitting) return;
    emit(
      state.copyWith(
        status: FridgeIntakeStatus.submitting,
        clearMessage: true,
        fieldErrors: const {},
        clearResult: true,
      ),
    );
    final result = await _shoppingRepo.confirmFridgeIntake(
      ConfirmFridgeIntakeParams(intakeId: state.intake.id, lines: state.lines),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FridgeIntakeStatus.failure,
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (confirm) => emit(
        state.copyWith(
          status: FridgeIntakeStatus.success,
          result: confirm,
          clearMessage: true,
        ),
      ),
    );
  }
}
