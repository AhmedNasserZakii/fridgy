import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/network_services/api_keys.dart';

class ServerFailure {
  ServerFailure(
    this.message, {
    this.statusCode,
    Map<String, List<String>>? fieldErrors,
  }) : fieldErrors = fieldErrors ?? const {};

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  String? firstErrorFor(String field) {
    final errors = fieldErrors[field];
    if (errors == null || errors.isEmpty) return null;
    return errors.first;
  }

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(LocaleKeys.connectionTimeOutWithApiServer.tr());
      case DioExceptionType.sendTimeout:
        return ServerFailure(LocaleKeys.sendTimeOutWithApiServer.tr());
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ServerFailure(LocaleKeys.receiveTimeOutWithApiServer.tr());
      case DioExceptionType.badCertificate:
        return ServerFailure(LocaleKeys.badCertificateWithApiServer.tr());
      case DioExceptionType.cancel:
        return ServerFailure(LocaleKeys.requestToApiServerWasCanceled.tr());
      case DioExceptionType.connectionError:
        return ServerFailure(LocaleKeys.connectionErrorWithApiServer.tr());
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final responseData = dioException.response?.data;
        if (statusCode != null) {
          return ServerFailure.fromResponse(statusCode, responseData);
        }
        return ServerFailure(_messageFromBody(responseData));
      case DioExceptionType.unknown:
        final message =
            dioException.message?.contains('SocketException') == true
            ? LocaleKeys.noInternetConnection.tr()
            : LocaleKeys.unknownErrorWithApiServer.tr();
        return ServerFailure(message);
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic body) {
    return ServerFailure(
      _messageFromBody(body),
      statusCode: statusCode,
      fieldErrors: _fieldErrorsFromBody(body),
    );
  }

  static String _messageFromBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      final message = body[ApiKeys.message];
      if (message is String && message.isNotEmpty) return message;
    }
    return LocaleKeys.anErrorOccurred.tr();
  }

  static Map<String, List<String>> _fieldErrorsFromBody(dynamic body) {
    if (body is! Map<String, dynamic>) return const {};
    final errors = body[ApiKeys.errors];
    if (errors is! Map) return const {};

    final result = <String, List<String>>{};
    errors.forEach((key, value) {
      if (key is! String) return;
      if (value is List) {
        final messages = value.whereType<String>().toList();
        if (messages.isNotEmpty) result[key] = messages;
      } else if (value is String && value.isNotEmpty) {
        result[key] = [value];
      }
    });
    return result;
  }
}
