import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/feature/notification/data/models/notification_model.dart';
import 'package:fridgy/feature/notification/data/models/notifications_page_model.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/domain/repos/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl({required this._apiService, required this._networkInfo});

  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<ServerFailure, NotificationsPage>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.notifications,
        requireAuth: true,
        queryParameters: {ApiKeys.page: page, ApiKeys.limit: limit},
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      final data = body[ApiKeys.data];
      final meta = body[ApiKeys.meta];
      if (data is! List || meta is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      return Right(
        NotificationsPageModel.fromJson(data: data, meta: meta).toEntity(),
      );
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'notifications repo dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'notifications repo catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, NotificationEntity>> markRead(String id) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.patch(
        WebConstant.notificationRead(id),
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

      return Right(NotificationModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'notification markRead dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'notification markRead catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, int>> markAllRead() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.post(
        WebConstant.notificationsReadAll,
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

      return Right(data[ApiKeys.updatedCount] as int);
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'notification markAllRead dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'notification markAllRead catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
