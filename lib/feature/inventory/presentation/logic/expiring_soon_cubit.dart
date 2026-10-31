import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/domain/params/expiring_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/presentation/logic/expiring_soon_state.dart';

class ExpiringSoonCubit extends Cubit<ExpiringSoonState> {
  ExpiringSoonCubit({required this._inventoryRepo})
    : super(const ExpiringSoonState()) {
    load();
  }

  final InventoryRepo _inventoryRepo;

  static const int _pageSize = 20;

  Future<void> load() async {
    if (isClosed) return;
    emit(
      state.copyWith(status: ExpiringSoonStatus.loading, clearMessage: true),
    );
    await _fetchFirstPage();
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    final result = await _inventoryRepo.getExpiring(
      const ExpiringParams(page: 1, limit: _pageSize),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExpiringSoonStatus.failure,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: data.items.isEmpty
              ? ExpiringSoonStatus.empty
              : ExpiringSoonStatus.success,
          items: data.items,
          meta: data.meta,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.status != ExpiringSoonStatus.success || !state.hasMore) return;
    final meta = state.meta;
    if (meta == null) return;

    emit(state.copyWith(status: ExpiringSoonStatus.loadingMore));
    final result = await _inventoryRepo.getExpiring(
      ExpiringParams(page: meta.page + 1, limit: _pageSize),
    );
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(status: ExpiringSoonStatus.success)),
      (data) => emit(
        state.copyWith(
          status: ExpiringSoonStatus.success,
          items: [...state.items, ...data.items],
          meta: data.meta,
        ),
      ),
    );
  }

  /// Skeleton-only layout data — never shown as real content.
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
    return [fake('1'), fake('2'), fake('3'), fake('4'), fake('5')];
  }
}
