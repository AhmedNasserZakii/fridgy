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
import 'package:fridgy/feature/more/data/models/notification_settings_model.dart';
import 'package:fridgy/feature/more/data/models/notification_settings_request_model.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';
import 'package:fridgy/feature/more/domain/params/update_notification_settings_params.dart';
import 'package:fridgy/feature/more/domain/repos/notification_settings_repo.dart';

class NotificationSettingsRepoImpl implements NotificationSettingsRepo {
  NotificationSettingsRepoImpl({
    required this._apiService,
    required this._networkInfo,
  });

  final ApiService _apiService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<ServerFailure, NotificationSettingsEntity>>
  getNotificationSettings() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.notificationSettings,
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

      return Right(NotificationSettingsModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'getNotificationSettings dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'getNotificationSettings catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, NotificationSettingsEntity>>
  updateNotificationSettings(UpdateNotificationSettingsParams params) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.put(
        WebConstant.notificationSettings,
        requireAuth: true,
        data: NotificationSettingsRequestModel(params).toJson(),
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      return Right(NotificationSettingsModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'updateNotificationSettings dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'updateNotificationSettings catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
