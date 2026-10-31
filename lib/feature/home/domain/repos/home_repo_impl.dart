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
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/home/data/models/home_dashboard_model.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';
import 'package:fridgy/feature/home/domain/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({
    required this._apiService,
    required this._networkInfo,
    required this._authRepo,
  });

  final ApiService _apiService;
  final NetworkInfo _networkInfo;
  final AuthRepo _authRepo;

  @override
  Future<Either<ServerFailure, HomeDashboardEntity>> getDashboard() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(ServerFailure(LocaleKeys.noInternetConnection.tr()));
      }

      final response = await _apiService.get(
        WebConstant.home,
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

      return Right(HomeDashboardModel.fromJson(data).toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'home repo dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: 'home repo catch: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  @override
  UserEntity? getCachedUser() => _authRepo.getCachedUser();
}
