import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';
import 'package:fridgy/feature/home/domain/repos/home_repo.dart';
import 'package:fridgy/feature/home/presentation/logic/home_state.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepo homeRepo})
    : _homeRepo = homeRepo,
      super(HomeState(user: homeRepo.getCachedUser())) {
    load();
  }

  final HomeRepo _homeRepo;

  Future<void> load() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        user: _homeRepo.getCachedUser(),
        clearMessage: true,
      ),
    );
    await _fetch();
  }

  Future<void> refresh() async {
    if (isClosed) return;
    await _fetch();
  }

  Future<void> _fetch() async {
    final result = await _homeRepo.getDashboard();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: failure.message,
          user: _homeRepo.getCachedUser(),
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          status: HomeStatus.loaded,
          dashboard: dashboard,
          user: _homeRepo.getCachedUser(),
          clearMessage: true,
        ),
      ),
    );
  }

  /// Skeleton-only layout data — never shown as real content.
  static HomeDashboardEntity skeletonDashboard() {
    final now = DateTime.now().toUtc();
    FoodItemEntity fake(String name) => FoodItemEntity(
      id: 'skeleton_$name',
      name: name,
      quantity: 100,
      unit: FoodUnit.g,
      storage: StorageLocation.fridge,
      isPartlyUsed: false,
      expiryDate: now,
      daysLeft: 1,
      expiryStatus: ExpiryStatus.useSoon,
      addedAt: now,
    );
    return HomeDashboardEntity(
      totalItems: 24,
      expiringSoonCount: 5,
      unreadNotificationsCount: 3,
      useFirst: [fake('Spinach'), fake('Berries'), fake('Chicken')],
    );
  }
}
