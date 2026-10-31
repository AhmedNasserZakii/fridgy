import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/params/expiring_params.dart';
import 'package:fridgy/feature/inventory/domain/params/list_inventory_params.dart';
import 'package:fridgy/feature/inventory/domain/params/search_params.dart';
import 'package:fridgy/feature/inventory/domain/params/upsert_food_params.dart';

abstract class InventoryRepo {
  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> list(
    ListInventoryParams params,
  );

  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> search(
    SearchParams params,
  );

  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> getExpiring(
    ExpiringParams params,
  );

  Future<Either<ServerFailure, FoodItemEntity>> getById(String id);

  Future<Either<ServerFailure, FoodItemEntity>> create(UpsertFoodParams params);

  Future<Either<ServerFailure, FoodItemEntity>> update(
    String id,
    UpsertFoodParams params,
  );

  /// Marks an item consumed. When [quantity] is null, the whole item is
  /// consumed. When set, the server reduces stock by that amount (partial use).
  Future<Either<ServerFailure, void>> consume(String id, {num? quantity});
}
