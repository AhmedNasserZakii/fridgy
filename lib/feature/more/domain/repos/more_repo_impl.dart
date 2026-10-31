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
import 'package:fridgy/feature/more/domain/repos/more_repo.dart';

class MoreRepoImpl implements MoreRepo {
  MoreRepoImpl({
    required this._apiService,
    required this._networkInfo,
    required this._localStorage,
  });

  final ApiService _apiService;
  final NetworkInfo _networkInfo;
  final LocalStorage _localStorage;

  @override
  Future<Either<ServerFailure, UserEntity>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.put(
        WebConstant.profile,
        requireAuth: true,
        data: {ApiKeys.name: name, ApiKeys.email: email},
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
      await _localStorage.setLastUserName(userModel.name);
      return Right(userModel.toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(message: 'updateProfile dio: $error', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(
        message: 'updateProfile catch: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }
}
