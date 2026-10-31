import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_confirm_result_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_entity.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';
import 'package:fridgy/feature/shopping/domain/params/add_cart_item_params.dart';
import 'package:fridgy/feature/shopping/domain/params/confirm_fridge_intake_params.dart';
import 'package:fridgy/feature/shopping/domain/params/list_catalog_params.dart';
import 'package:fridgy/feature/shopping/domain/params/upsert_shopping_list_item_params.dart';

abstract class ShoppingRepo {
  Future<Either<ServerFailure, List<ShoppingListItemEntity>>> getList();

  Future<Either<ServerFailure, ShoppingListItemEntity>> addListItem(
    UpsertShoppingListItemParams params,
  );

  Future<Either<ServerFailure, ShoppingListItemEntity>> updateListItem(
    String id,
    UpsertShoppingListItemParams params,
  );

  Future<Either<ServerFailure, void>> deleteListItem(String id);

  Future<Either<ServerFailure, ShoppingListItemEntity>> toggleListItem(
    String id,
  );

  Future<Either<ServerFailure, FridgeIntakeEntity>> completeList();

  Future<Either<ServerFailure, PaginatedList<CatalogProductEntity>>> getCatalog(
    ListCatalogParams params,
  );

  Future<Either<ServerFailure, CatalogProductEntity>> getCatalogProduct(
    String id,
  );

  Future<Either<ServerFailure, CartEntity>> getCart();

  Future<Either<ServerFailure, CartEntity>> addCartItem(
    AddCartItemParams params,
  );

  Future<Either<ServerFailure, CartEntity>> updateCartItem(
    String id, {
    required num quantity,
  });

  Future<Either<ServerFailure, CartEntity>> removeCartItem(String id);

  Future<Either<ServerFailure, CartEntity>> clearCart();

  Future<Either<ServerFailure, OrderEntity>> placeOrder();

  Future<Either<ServerFailure, PaginatedList<OrderEntity>>> getOrders({
    int page = 1,
    int limit = 20,
  });

  Future<Either<ServerFailure, OrderEntity>> getOrder(String id);

  Future<Either<ServerFailure, FridgeIntakeEntity>> completeOrder(String id);

  Future<Either<ServerFailure, FridgeIntakeConfirmResultEntity>>
  confirmFridgeIntake(ConfirmFridgeIntakeParams params);
}
