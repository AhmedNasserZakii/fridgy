import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_model.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/feature/shopping/data/models/cart_model.dart';
import 'package:fridgy/feature/shopping/data/models/catalog_product_model.dart';
import 'package:fridgy/feature/shopping/data/models/fridge_intake_confirm_result_model.dart';
import 'package:fridgy/feature/shopping/data/models/fridge_intake_line_model.dart';
import 'package:fridgy/feature/shopping/data/models/fridge_intake_model.dart';
import 'package:fridgy/feature/shopping/data/models/order_model.dart';
import 'package:fridgy/feature/shopping/data/models/shopping_list_item_model.dart';
import 'package:fridgy/feature/shopping/data/models/upsert_shopping_list_request_model.dart';
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
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';

class ShoppingRepoImpl implements ShoppingRepo {
  ShoppingRepoImpl({required this._apiService, required this._networkInfo});

  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<ServerFailure, List<ShoppingListItemEntity>>> getList() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.shoppingList,
        requireAuth: true,
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! List) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(
        data
            .whereType<Map<String, dynamic>>()
            .map(ShoppingListItemModel.fromJson)
            .map((m) => m.toEntity())
            .toList(),
      );
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping getList dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: 'shopping getList: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, ShoppingListItemEntity>> addListItem(
    UpsertShoppingListItemParams params,
  ) {
    return _parseListItem(
      label: 'shopping addListItem',
      request: () => _apiService.post(
        WebConstant.shoppingList,
        data: UpsertShoppingListRequestModel(params: params).toJson(),
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, ShoppingListItemEntity>> updateListItem(
    String id,
    UpsertShoppingListItemParams params,
  ) {
    return _parseListItem(
      label: 'shopping updateListItem',
      request: () => _apiService.put(
        WebConstant.shoppingListItem(id),
        data: UpsertShoppingListRequestModel(params: params).toJson(),
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, void>> deleteListItem(String id) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      await _apiService.delete(
        WebConstant.shoppingListItem(id),
        requireAuth: true,
      );
      return const Right(null);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping deleteListItem dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'shopping deleteListItem: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, ShoppingListItemEntity>> toggleListItem(
    String id,
  ) {
    return _parseListItem(
      label: 'shopping toggleListItem',
      request: () => _apiService.post(
        WebConstant.shoppingListToggle(id),
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, FridgeIntakeEntity>> completeList() {
    return _parseIntake(
      label: 'shopping completeList',
      request: () =>
          _apiService.post(WebConstant.shoppingListComplete, requireAuth: true),
    );
  }

  @override
  Future<Either<ServerFailure, PaginatedList<CatalogProductEntity>>> getCatalog(
    ListCatalogParams params,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await _apiService.get(
        WebConstant.shoppingCatalog,
        requireAuth: true,
        queryParameters: params.toQuery(),
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      final metaRaw = body[ApiKeys.meta];
      if (data is! List || metaRaw is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(CatalogProductModel.fromJson)
          .map((m) => m.toEntity())
          .toList();
      return Right(
        PaginatedList(
          items: items,
          meta: PaginationMetaModel.fromJson(metaRaw).toEntity(),
        ),
      );
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping getCatalog dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'shopping getCatalog: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, CatalogProductEntity>> getCatalogProduct(
    String id,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await _apiService.get(
        WebConstant.shoppingCatalogProduct(id),
        requireAuth: true,
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(CatalogProductModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping getCatalogProduct dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'shopping getCatalogProduct: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, CartEntity>> getCart() {
    return _parseCart(
      label: 'shopping getCart',
      request: () =>
          _apiService.get(WebConstant.shoppingCart, requireAuth: true),
    );
  }

  @override
  Future<Either<ServerFailure, CartEntity>> addCartItem(
    AddCartItemParams params,
  ) {
    return _parseCart(
      label: 'shopping addCartItem',
      request: () => _apiService.post(
        WebConstant.shoppingCartItems,
        data: {
          ApiKeys.catalogProductId: params.catalogProductId,
          ApiKeys.quantity: params.quantity,
        },
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, CartEntity>> updateCartItem(
    String id, {
    required num quantity,
  }) {
    return _parseCart(
      label: 'shopping updateCartItem',
      request: () => _apiService.put(
        WebConstant.shoppingCartItem(id),
        data: {ApiKeys.quantity: quantity},
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, CartEntity>> removeCartItem(String id) {
    return _parseCart(
      label: 'shopping removeCartItem',
      request: () => _apiService.delete(
        WebConstant.shoppingCartItem(id),
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, CartEntity>> clearCart() {
    return _parseCart(
      label: 'shopping clearCart',
      request: () =>
          _apiService.delete(WebConstant.shoppingCart, requireAuth: true),
    );
  }

  @override
  Future<Either<ServerFailure, OrderEntity>> placeOrder() {
    return _parseOrder(
      label: 'shopping placeOrder',
      request: () =>
          _apiService.post(WebConstant.shoppingOrders, requireAuth: true),
    );
  }

  @override
  Future<Either<ServerFailure, PaginatedList<OrderEntity>>> getOrders({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await _apiService.get(
        WebConstant.shoppingOrders,
        requireAuth: true,
        queryParameters: {ApiKeys.page: page, ApiKeys.limit: limit},
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      final metaRaw = body[ApiKeys.meta];
      if (data is! List || metaRaw is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .map((m) => m.toEntity())
          .toList();
      return Right(
        PaginatedList(
          items: items,
          meta: PaginationMetaModel.fromJson(metaRaw).toEntity(),
        ),
      );
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping getOrders dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: 'shopping getOrders: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, OrderEntity>> getOrder(String id) {
    return _parseOrder(
      label: 'shopping getOrder',
      request: () =>
          _apiService.get(WebConstant.shoppingOrder(id), requireAuth: true),
    );
  }

  @override
  Future<Either<ServerFailure, FridgeIntakeEntity>> completeOrder(String id) {
    return _parseIntake(
      label: 'shopping completeOrder',
      request: () => _apiService.post(
        WebConstant.shoppingOrderComplete(id),
        requireAuth: true,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, FridgeIntakeConfirmResultEntity>>
  confirmFridgeIntake(ConfirmFridgeIntakeParams params) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await _apiService.post(
        WebConstant.shoppingFridgeIntakeConfirm(params.intakeId),
        data: {
          ApiKeys.lines: params.lines
              .map((line) => FridgeIntakeLineModel.fromEntity(line).toJson())
              .toList(),
        },
        requireAuth: true,
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(FridgeIntakeConfirmResultModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'shopping confirmFridgeIntake dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'shopping confirmFridgeIntake: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<Either<ServerFailure, ShoppingListItemEntity>> _parseListItem({
    required String label,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(ShoppingListItemModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(message: '$label dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<Either<ServerFailure, CartEntity>> _parseCart({
    required String label,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(CartModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(message: '$label dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<Either<ServerFailure, OrderEntity>> _parseOrder({
    required String label,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(OrderModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(message: '$label dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<Either<ServerFailure, FridgeIntakeEntity>> _parseIntake({
    required String label,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      return Right(FridgeIntakeModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(message: '$label dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
