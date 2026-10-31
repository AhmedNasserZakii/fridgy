import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({required this._shoppingRepo})
    : super(const OrderDetailState());

  final ShoppingRepo _shoppingRepo;

  Future<void> load(String id) async {
    emit(
      state.copyWith(
        status: OrderDetailStatus.loading,
        clearMessage: true,
        clearIntake: true,
        actionStatus: OrderDetailActionStatus.idle,
      ),
    );
    final result = await _shoppingRepo.getOrder(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          message: failure.message,
        ),
      ),
      (order) => emit(
        state.copyWith(
          status: OrderDetailStatus.success,
          order: order,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> markReceived() async {
    final order = state.order;
    if (isClosed ||
        order == null ||
        state.actionStatus == OrderDetailActionStatus.working) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: OrderDetailActionStatus.working,
        clearMessage: true,
        clearIntake: true,
      ),
    );
    final result = await _shoppingRepo.completeOrder(order.id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: OrderDetailActionStatus.failure,
          message: failure.message,
        ),
      ),
      (intake) => emit(
        state.copyWith(
          actionStatus: OrderDetailActionStatus.intakeReady,
          intake: intake,
        ),
      ),
    );
  }
}
