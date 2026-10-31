import 'package:dio/dio.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/core/network_services/token_interceptor.dart';

class ApiService {
  ApiService({required this._dio, required this._localStorage});

  final Dio _dio;
  final LocalStorage _localStorage;

  Future<Response<dynamic>> get(
    String path, {
    bool requireAuth = false,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: _options(requireAuth: requireAuth),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    bool requireAuth = false,
  }) {
    return _dio.post<dynamic>(
      path,
      data: data,
      options: _options(requireAuth: requireAuth),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    bool requireAuth = false,
  }) {
    return _dio.put<dynamic>(
      path,
      data: data,
      options: _options(requireAuth: requireAuth),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    bool requireAuth = false,
  }) {
    return _dio.patch<dynamic>(
      path,
      data: data,
      options: _options(requireAuth: requireAuth),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    bool requireAuth = false,
  }) {
    return _dio.delete<dynamic>(
      path,
      data: data,
      options: _options(requireAuth: requireAuth),
    );
  }

  Options _options({required bool requireAuth}) {
    return Options(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': _localStorage.getLocaleLanguage(),
      },
      extra: {TokenInterceptor.requireAuthExtra: requireAuth},
    );
  }
}
