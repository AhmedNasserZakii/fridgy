import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/shopping/domain/params/list_catalog_params.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/presentation/logic/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({required this._shoppingRepo}) : super(const CatalogState()) {
    load();
  }

  final ShoppingRepo _shoppingRepo;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> load({bool refresh = true}) async {
    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        clearMessage: true,
        items: refresh ? const [] : state.items,
      ),
    );
    await _fetch(page: 1, append: false);
  }

  void queryChanged(String value) {
    emit(state.copyWith(query: value));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), load);
  }

  void categoryChanged(FoodCategory? category) {
    emit(state.copyWith(category: category, clearCategory: category == null));
    load();
  }

  Future<void> loadMore() async {
    if (isClosed ||
        !state.hasMore ||
        state.status == CatalogStatus.loading ||
        state.status == CatalogStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: CatalogStatus.loadingMore));
    await _fetch(page: (state.meta?.page ?? 1) + 1, append: true);
  }

  Future<void> _fetch({required int page, required bool append}) async {
    final result = await _shoppingRepo.getCatalog(
      ListCatalogParams(q: state.query, category: state.category, page: page),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: CatalogStatus.failure, message: failure.message),
      ),
      (pageData) {
        final items = append
            ? [...state.items, ...pageData.items]
            : pageData.items;
        emit(
          state.copyWith(
            status: items.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
            items: items,
            meta: pageData.meta,
            clearMessage: true,
          ),
        );
      },
    );
  }
}
