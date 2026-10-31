import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/shopping/domain/params/add_cart_item_params.dart';
import 'package:fridgy/feature/shopping/domain/params/upsert_shopping_list_item_params.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required this._shoppingRepo})
    : super(const ProductDetailState());

  final ShoppingRepo _shoppingRepo;

  Future<void> load(String id) async {
    emit(
      state.copyWith(
        status: ProductDetailStatus.loading,
        clearMessage: true,
        actionStatus: ProductDetailActionStatus.idle,
      ),
    );
    final result = await _shoppingRepo.getCatalogProduct(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          message: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          product: product,
          quantity: product.defaultQuantity,
          clearMessage: true,
        ),
      ),
    );
  }

  void quantityChanged(num value) => emit(state.copyWith(quantity: value));

  Future<void> addToCart() async {
    final product = state.product;
    if (isClosed ||
        product == null ||
        state.actionStatus == ProductDetailActionStatus.working) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: ProductDetailActionStatus.working,
        clearMessage: true,
      ),
    );
    final result = await _shoppingRepo.addCartItem(
      AddCartItemParams(catalogProductId: product.id, quantity: state.quantity),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ProductDetailActionStatus.failure,
          message: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(actionStatus: ProductDetailActionStatus.addedToCart),
      ),
    );
  }

  Future<void> addToList() async {
    final product = state.product;
    if (isClosed ||
        product == null ||
        state.actionStatus == ProductDetailActionStatus.working) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: ProductDetailActionStatus.working,
        clearMessage: true,
      ),
    );
    final result = await _shoppingRepo.addListItem(
      UpsertShoppingListItemParams(
        name: product.name,
        quantity: state.quantity,
        unit: product.unit,
        category: product.category,
        imageUrl: product.imageUrl,
        catalogProductId: product.id,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ProductDetailActionStatus.failure,
          message: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(actionStatus: ProductDetailActionStatus.addedToList),
      ),
    );
  }
}
