import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_entity.dart';
import 'package:fridgy/feature/shopping/domain/params/add_cart_item_params.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this._shoppingRepo}) : super(const CartState()) {
    load();
  }

  final ShoppingRepo _shoppingRepo;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: CartStatus.loading,
        clearMessage: true,
        clearPlacedOrder: true,
        actionStatus: CartActionStatus.idle,
      ),
    );
    final result = await _shoppingRepo.getCart();
    if (isClosed) return;
    _emitCart(result);
  }

  Future<void> addProduct({
    required String catalogProductId,
    required num quantity,
  }) async {
    if (isClosed || state.actionStatus == CartActionStatus.working) return;
    emit(
      state.copyWith(
        actionStatus: CartActionStatus.working,
        clearMessage: true,
      ),
    );
    final result = await _shoppingRepo.addCartItem(
      AddCartItemParams(catalogProductId: catalogProductId, quantity: quantity),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CartActionStatus.failure,
          message: failure.message,
        ),
      ),
      (cart) => _applyCart(cart, actionStatus: CartActionStatus.idle),
    );
  }

  Future<void> updateQuantity(String itemId, num quantity) async {
    if (isClosed || state.actionStatus == CartActionStatus.working) return;
    emit(state.copyWith(actionStatus: CartActionStatus.working));
    final result = await _shoppingRepo.updateCartItem(
      itemId,
      quantity: quantity,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CartActionStatus.failure,
          message: failure.message,
        ),
      ),
      (cart) => _applyCart(cart, actionStatus: CartActionStatus.idle),
    );
  }

  Future<void> removeItem(String itemId) async {
    if (isClosed || state.actionStatus == CartActionStatus.working) return;
    emit(state.copyWith(actionStatus: CartActionStatus.working));
    final result = await _shoppingRepo.removeCartItem(itemId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CartActionStatus.failure,
          message: failure.message,
        ),
      ),
      (cart) => _applyCart(cart, actionStatus: CartActionStatus.idle),
    );
  }

  Future<void> placeOrder() async {
    if (isClosed || state.actionStatus == CartActionStatus.working) return;
    emit(
      state.copyWith(
        actionStatus: CartActionStatus.working,
        clearMessage: true,
        clearPlacedOrder: true,
      ),
    );
    final result = await _shoppingRepo.placeOrder();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: CartActionStatus.failure,
          message: failure.message,
        ),
      ),
      (order) async {
        emit(
          state.copyWith(
            actionStatus: CartActionStatus.orderPlaced,
            placedOrder: order,
          ),
        );
        await load();
      },
    );
  }

  void _emitCart(Either<ServerFailure, CartEntity> result) {
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          message: failure.message,
          actionStatus: CartActionStatus.idle,
        ),
      ),
      (cart) => _applyCart(cart, actionStatus: CartActionStatus.idle),
    );
  }

  void _applyCart(CartEntity cart, {required CartActionStatus actionStatus}) {
    emit(
      state.copyWith(
        status: cart.isEmpty ? CartStatus.empty : CartStatus.success,
        cart: cart,
        actionStatus: actionStatus,
        clearMessage: true,
      ),
    );
  }
}
