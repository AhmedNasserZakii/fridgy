import 'package:dio/dio.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/core/local_storage/secure_storage.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/core/utils/app_route.dart';

class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({
    required this._secureStorage,
    required this._localStorage,
    Dio? refreshDio,
  }) : _refreshDio =
           refreshDio ??
           Dio(
             BaseOptions(
               baseUrl: WebConstant.baseUrl,
               connectTimeout: const Duration(seconds: 60),
               receiveTimeout: const Duration(seconds: 60),
               sendTimeout: const Duration(seconds: 60),
               headers: const {
                 'Accept': 'application/json',
                 'Content-Type': 'application/json',
               },
             ),
           );

  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;
  final Dio _refreshDio;

  static const String requireAuthExtra = 'requireAuth';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requireAuth = options.extra[requireAuthExtra] == true;
    if (requireAuth) {
      final token = await _secureStorage.getAccessToken();
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requireAuth = err.requestOptions.extra[requireAuthExtra] == true;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!requireAuth ||
        alreadyRetried ||
        err.response?.statusCode != 401 ||
        err.requestOptions.path.contains(WebConstant.refresh)) {
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken.isEmpty) {
        await _clearSessionAndGoToSignIn();
        handler.next(err);
        return;
      }

      final refreshResponse = await _refreshDio.post<dynamic>(
        WebConstant.refresh,
        data: {ApiKeys.refreshToken: refreshToken},
      );

      final body = refreshResponse.data;
      if (body is! Map<String, dynamic>) {
        await _clearSessionAndGoToSignIn();
        handler.next(err);
        return;
      }

      final data = body[ApiKeys.data];
      if (data is! Map<String, dynamic>) {
        await _clearSessionAndGoToSignIn();
        handler.next(err);
        return;
      }

      final accessToken = data[ApiKeys.accessToken] as String? ?? '';
      final newRefreshToken = data[ApiKeys.refreshToken] as String? ?? '';
      if (accessToken.isEmpty || newRefreshToken.isEmpty) {
        await _clearSessionAndGoToSignIn();
        handler.next(err);
        return;
      }

      await _secureStorage.setAccessToken(accessToken);
      await _secureStorage.setRefreshToken(newRefreshToken);

      final user = data[ApiKeys.user];
      if (user is Map<String, dynamic>) {
        await _localStorage.setCachedUser(user);
      }

      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $accessToken';
      requestOptions.extra['retried'] = true;

      final response = await getIt<Dio>().fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } catch (_) {
      await _clearSessionAndGoToSignIn();
      handler.next(err);
    }
  }

  Future<void> _clearSessionAndGoToSignIn() async {
    await _secureStorage.clearTokens();
    await _localStorage.clearCachedUser();

    final navigator = AppRoute.navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil(AppRoute.signIn, (_) => false);
    }
  }
}
