import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/core/local_storage/secure_storage.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/feature/auth/data/models/auth_session_model.dart';
import 'package:fridgy/feature/auth/data/models/login_request_model.dart';
import 'package:fridgy/feature/auth/data/models/register_request_model.dart';
import 'package:fridgy/feature/auth/data/models/user_model.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/auth/domain/params/login_params.dart';
import 'package:fridgy/feature/auth/domain/params/register_params.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({
    required this._apiService,
    required this._networkInfo,
    required this._secureStorage,
    required this._localStorage,
  });

  final ApiService _apiService;
  final NetworkInfo _networkInfo;
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;

  @override
  Future<Either<ServerFailure, UserEntity>> register(
    RegisterParams params,
  ) async {
    return _authenticate(
      request: () => _apiService.post(
        WebConstant.register,
        data: RegisterRequestModel.fromParams(params).toJson(),
      ),
    );
  }

  @override
  Future<Either<ServerFailure, UserEntity>> login(LoginParams params) async {
    return _authenticate(
      request: () => _apiService.post(
        WebConstant.login,
        data: LoginRequestModel.fromParams(params).toJson(),
      ),
    );
  }

  Future<Either<ServerFailure, UserEntity>> _authenticate({
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

      final session = AuthSessionModel.fromJson(data);
      await _saveSession(session);
      return Right(session.user.toEntity());
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'auth repo dio exception: $error',
        stackTrace: stackTrace,
      );
      return Left(ServerFailure.fromDioException(error));
    } catch (error, stackTrace) {
      printDebug(message: 'auth repo catch: $error', stackTrace: stackTrace);
      return Left(ServerFailure(LocaleKeys.anErrorOccurred.tr()));
    }
  }

  Future<void> _saveSession(AuthSessionModel session) async {
    await _secureStorage.setAccessToken(session.accessToken);
    await _secureStorage.setRefreshToken(session.refreshToken);
    await _localStorage.setCachedUser(session.user.toJson());
    await _localStorage.setLastUserName(session.user.name);
  }

  @override
  String? getLastUserName() => _localStorage.getLastUserName();

  @override
  Future<bool> hasAccessToken() async {
    final token = await _secureStorage.getAccessToken();
    return token.trim().isNotEmpty;
  }

  @override
  UserEntity? getCachedUser() {
    final json = _localStorage.getCachedUser();
    if (json == null) return null;
    try {
      return UserModel.fromJson(json).toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Either<ServerFailure, Unit>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _apiService.post(WebConstant.logout, requireAuth: true);
      }
    } on DioException catch (error, stackTrace) {
      printDebug(
        message: 'auth logout dio exception: $error',
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      printDebug(message: 'auth logout catch: $error', stackTrace: stackTrace);
    } finally {
      await _secureStorage.clearTokens();
      await _localStorage.clearCachedUser();
    }
    return const Right(unit);
  }
}
