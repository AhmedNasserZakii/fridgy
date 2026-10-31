import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_sort.dart';
import 'package:fridgy/feature/inventory/domain/entities/inventory_status_filter.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/domain/params/list_inventory_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_state.dart';

class MyFridgeCubit extends Cubit<MyFridgeState> {
  MyFridgeCubit({required this._inventoryRepo}) : super(const MyFridgeState()) {
    load();
  }

  final InventoryRepo _inventoryRepo;

  static const int _pageSize = 20;
  static const Duration _debounce = Duration(milliseconds: 400);

  Timer? _debounceTimer;
  int _fetchToken = 0;

  ListInventoryParams _params({required int page}) {
    return ListInventoryParams(
      storage: state.storage,
      category: state.category,
      q: state.query.trim().isEmpty ? null : state.query.trim(),
      status: state.statusFilter,
      expiresWithinDays: state.expiresWithinDays,
      sort: state.sort,
      includeOutOfStock: true,
      page: page,
      limit: _pageSize,
    );
  }

  Future<void> load() async {
    if (isClosed) return;
    emit(state.copyWith(status: MyFridgeStatus.loading, clearMessage: true));
    await _fetchFirstPage();
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    final token = ++_fetchToken;
    final result = await _inventoryRepo.list(_params(page: 1));
    if (isClosed || token != _fetchToken) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MyFridgeStatus.failure,
          message: failure.message,
        ),
      ),
      (data) {
        final nextStatus = data.items.isEmpty
            ? MyFridgeStatus.empty
            : MyFridgeStatus.success;
        emit(
          state.copyWith(
            status: nextStatus,
            items: data.items,
            meta: data.meta,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.status != MyFridgeStatus.success || !state.hasMore) return;
    final meta = state.meta;
    if (meta == null) return;

    final token = _fetchToken;
    emit(state.copyWith(status: MyFridgeStatus.loadingMore));

    final result = await _inventoryRepo.list(_params(page: meta.page + 1));
    if (isClosed || token != _fetchToken) return;

    result.fold(
      (_) => emit(state.copyWith(status: MyFridgeStatus.success)),
      (data) => emit(
        state.copyWith(
          status: MyFridgeStatus.success,
          items: [...state.items, ...data.items],
          meta: data.meta,
        ),
      ),
    );
  }

  Future<void> setStorage(StorageLocation? storage) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        storage: storage,
        clearStorage: storage == null,
        status: MyFridgeStatus.loading,
        clearMessage: true,
      ),
    );
    await _fetchFirstPage();
  }

  Future<void> setCategory(FoodCategory? category) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        category: category,
        clearCategory: category == null,
        status: MyFridgeStatus.loading,
        clearMessage: true,
      ),
    );
    await _fetchFirstPage();
  }

  void setQuery(String value) {
    if (isClosed) return;
    _debounceTimer?.cancel();
    emit(state.copyWith(query: value, clearMessage: true));

    _debounceTimer = Timer(_debounce, () async {
      if (isClosed) return;
      emit(state.copyWith(status: MyFridgeStatus.loading, clearMessage: true));
      await _fetchFirstPage();
    });
  }

  Future<void> applySheetFilters({
    StorageLocation? storage,
    FoodCategory? category,
    InventoryStatusFilter? statusFilter,
    int? expiresWithinDays,
    InventorySort? sort,
    bool clearStorage = false,
    bool clearCategory = false,
    bool clearStatusFilter = false,
    bool clearExpiresWithinDays = false,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        storage: storage,
        category: category,
        statusFilter: statusFilter,
        expiresWithinDays: expiresWithinDays,
        sort: sort,
        clearStorage: clearStorage,
        clearCategory: clearCategory,
        clearStatusFilter: clearStatusFilter,
        clearExpiresWithinDays: clearExpiresWithinDays,
        status: MyFridgeStatus.loading,
        clearMessage: true,
      ),
    );
    await _fetchFirstPage();
  }

  Future<void> resetFilters() async {
    if (isClosed) return;
    emit(const MyFridgeState(status: MyFridgeStatus.loading));
    await _fetchFirstPage();
  }

  static List<FoodItemEntity> skeletonItems() {
    final now = DateTime.now().toUtc();
    FoodItemEntity fake(String id) => FoodItemEntity(
      id: 'skeleton_$id',
      name: 'Food item name',
      quantity: 250,
      unit: FoodUnit.g,
      storage: StorageLocation.fridge,
      isPartlyUsed: false,
      expiryDate: now,
      daysLeft: 1,
      expiryStatus: ExpiryStatus.useSoon,
      addedAt: now,
    );
    return [fake('1'), fake('2'), fake('3'), fake('4')];
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
