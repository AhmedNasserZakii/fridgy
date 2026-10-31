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
import 'package:fridgy/feature/inventory/data/models/food_item_model.dart';
import 'package:fridgy/feature/inventory/data/models/upsert_food_request_model.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/params/expiring_params.dart';
import 'package:fridgy/feature/inventory/domain/params/list_inventory_params.dart';
import 'package:fridgy/feature/inventory/domain/params/search_params.dart';
import 'package:fridgy/feature/inventory/domain/params/upsert_food_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';

class InventoryRepoImpl implements InventoryRepo {
  InventoryRepoImpl({required this._apiService, required this._networkInfo});

  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> list(
    ListInventoryParams params,
  ) {
    return _fetchList(
      path: WebConstant.inventory,
      query: params.toQuery(),
      label: 'inventory list',
    );
  }

  @override
  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> search(
    SearchParams params,
  ) {
    return _fetchList(
      path: WebConstant.inventorySearch,
      query: params.toQuery(),
      label: 'inventory search',
    );
  }

  @override
  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> getExpiring(
    ExpiringParams params,
  ) {
    return _fetchList(
      path: WebConstant.inventoryExpiring,
      query: params.toQuery(),
      label: 'inventory expiring',
    );
  }

  @override
  Future<Either<ServerFailure, FoodItemEntity>> getById(String id) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.inventoryItem(id),
        requireAuth: true,
      );
      return _parseItemResponse(response.data, label: 'inventory getById');
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'inventory getById dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'inventory getById catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, FoodItemEntity>> create(
    UpsertFoodParams params,
  ) async {
    return _upsert(
      request: () => _apiService.post(
        WebConstant.inventory,
        data: UpsertFoodRequestModel(params: params).toJson(),
        requireAuth: true,
      ),
      label: 'inventory create',
    );
  }

  @override
  Future<Either<ServerFailure, FoodItemEntity>> update(
    String id,
    UpsertFoodParams params,
  ) async {
    return _upsert(
      request: () => _apiService.put(
        WebConstant.inventoryItem(id),
        data: UpsertFoodRequestModel(params: params).toJson(),
        requireAuth: true,
      ),
      label: 'inventory update',
    );
  }

  @override
  Future<Either<ServerFailure, void>> consume(String id) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      await _apiService.post(
        WebConstant.inventoryConsume(id),
        requireAuth: true,
      );
      return const Right(null);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'inventory consume dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'inventory consume catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<Either<ServerFailure, FoodItemEntity>> _upsert({
    required Future<Response<dynamic>> Function() request,
    required String label,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await request();
      return _parseItemResponse(response.data, label: label);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: '$label dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label catch: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Either<ServerFailure, FoodItemEntity> _parseItemResponse(
    dynamic body, {
    required String label,
  }) {
    if (body is! Map<String, dynamic>) {
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }

    final data = body[ApiKeys.data];
    if (data is! Map<String, dynamic>) {
      printDebug(message: '$label invalid data envelope');
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }

    return Right(FoodItemModel.fromJson(data).toEntity());
  }

  Future<Either<ServerFailure, PaginatedList<FoodItemEntity>>> _fetchList({
    required String path,
    required Map<String, dynamic> query,
    required String label,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        path,
        requireAuth: true,
        queryParameters: query,
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
          .map(FoodItemModel.fromJson)
          .map((m) => m.toEntity())
          .toList();
      final meta = PaginationMetaModel.fromJson(metaRaw).toEntity();
      return Right(PaginatedList(items: items, meta: meta));
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: '$label dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: '$label catch: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
