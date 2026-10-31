import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required this._shoppingRepo}) : super(const OrdersState()) {
    load();
  }

  final ShoppingRepo _shoppingRepo;

  Future<void> load() async {
    emit(state.copyWith(status: OrdersStatus.loading, clearMessage: true));
    final result = await _shoppingRepo.getOrders();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: OrdersStatus.failure, message: failure.message),
      ),
      (page) => emit(
        state.copyWith(
          status: page.items.isEmpty
              ? OrdersStatus.empty
              : OrdersStatus.success,
          orders: page.items,
          meta: page.meta,
          clearMessage: true,
        ),
      ),
    );
  }
}
