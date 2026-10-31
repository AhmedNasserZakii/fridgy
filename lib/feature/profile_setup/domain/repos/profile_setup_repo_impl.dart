import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/feature/auth/data/models/user_model.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/profile_setup/data/models/preferences_request_model.dart';
import 'package:fridgy/feature/profile_setup/data/models/preferences_response_model.dart';
import 'package:fridgy/feature/profile_setup/data/models/setup_options_model.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/setup_options_entity.dart';
import 'package:fridgy/feature/profile_setup/domain/params/profile_preferences_params.dart';
import 'package:fridgy/feature/profile_setup/domain/repos/profile_setup_repo.dart';

class ProfileSetupRepoImpl implements ProfileSetupRepo {
  ProfileSetupRepoImpl({
    required this._apiService,
    required this._networkInfo,
    required this._localStorage,
  });

  final ApiService _apiService;
  final NetworkInfo _networkInfo;
  final LocalStorage _localStorage;

  @override
  Future<Either<ServerFailure, SetupOptionsEntity>> getSetupOptions() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.setupOptions,
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

      return Right(SetupOptionsModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'getSetupOptions dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'getSetupOptions catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, ProfilePreferencesParams>>
  getPreferences() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.preferences,
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

      return Right(PreferencesResponseModel.fromJson(data).toParams());
    } on DioException catch (error, stackTrace) {
      printDebug(message: 'getPreferences dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'getPreferences catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  Future<Either<ServerFailure, UserEntity>> savePreferences(
    ProfilePreferencesParams params,
  ) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.put(
        WebConstant.preferences,
        requireAuth: true,
        data: PreferencesRequestModel.fromParams(params).toJson(),
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }
      final userJson = data[ApiKeys.user];
      if (userJson is! Map<String, dynamic>) {
        return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
      }

      final userModel = UserModel.fromJson(userJson);
      await _localStorage.setCachedUser(userModel.toJson());
      return Right(userModel.toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'savePreferences dio: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'savePreferences catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
