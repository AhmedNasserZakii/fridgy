import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fridgy/core/network_services/mock/mock_response.dart';
import 'package:fridgy/core/network_services/mock/mock_routes.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/core/network_services/api_mode_controller.dart';

class MockInterceptor extends Interceptor {
  MockInterceptor({required this._apiMode});

  final ApiModeController _apiMode;

  static const Duration _delay = Duration(milliseconds: 600);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_apiMode.useMocks) {
      handler.next(options);
      return;
    }

    final path = _pathWithoutQuery(options.path);
    final mock = MockRoutes.resolve(options.method, path);
    if (mock == null) {
      handler.next(options);
      return;
    }

    await Future<void>.delayed(_delay);

    final resolved = await _resolveAsset(options, path, mock);
    final raw = await rootBundle.loadString(resolved.assetPath);
    final decoded = jsonDecode(raw);
    final response = Response<dynamic>(
      requestOptions: options,
      data: decoded,
      statusCode: resolved.statusCode,
      statusMessage: resolved.statusCode >= 400 ? 'Error' : 'OK',
    );

    if (resolved.statusCode >= 200 && resolved.statusCode < 300) {
      handler.resolve(response);
      return;
    }

    handler.reject(
      DioException.badResponse(
        statusCode: resolved.statusCode,
        requestOptions: options,
        response: response,
      ),
    );
  }

  String _pathWithoutQuery(String path) {
    final withoutSlash = path.replaceFirst(RegExp(r'^/'), '');
    final queryIndex = withoutSlash.indexOf('?');
    if (queryIndex < 0) return withoutSlash;
    return withoutSlash.substring(0, queryIndex);
  }

  Future<MockResponse> _resolveAsset(
    RequestOptions options,
    String path,
    MockResponse mock,
  ) async {
    if (path == WebConstant.fridgeAiMessages &&
        options.method.toUpperCase() == 'POST') {
      return _resolveFridgeAiMessage(options, mock);
    }

    if (path != WebConstant.inventorySearch) return mock;

    final q = options.queryParameters['q']?.toString() ?? '';
    if (q.trim().length < 2) return mock;

    final hasMatch = await _searchHasMatch(q.trim());
    if (hasMatch) return mock;
    return MockRoutes.searchEmpty;
  }

  MockResponse _resolveFridgeAiMessage(
    RequestOptions options,
    MockResponse mock,
  ) {
    final key = 'POST ${WebConstant.fridgeAiMessages}';
    if (MockRoutes.overrides.containsKey(key)) return mock;

    final data = options.data;
    if (data is! Map) return MockRoutes.fridgeAiMessagesAddFood;

    final mode = data['mode']?.toString();
    if (mode == 'use_food') {
      return MockRoutes.fridgeAiMessagesUseFood;
    }

    final message = (data['message']?.toString() ?? '').toLowerCase().trim();
    final needsQuantity =
        message.contains('some milk') ||
        (message.contains('bought') &&
            message.contains('milk') &&
            !RegExp(r'\d').hasMatch(message));
    if (needsQuantity) {
      return MockRoutes.fridgeAiMessagesClarification;
    }

    return MockRoutes.fridgeAiMessagesAddFood;
  }

  Future<bool> _searchHasMatch(String query) async {
    try {
      final raw = await rootBundle.loadString(
        'assets/mocks/inventory/get_search.json',
      );
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return false;
      final data = decoded['data'];
      if (data is! List) return false;
      final lower = query.toLowerCase();
      for (final item in data) {
        if (item is! Map) continue;
        final name = item['name']?.toString() ?? '';
        if (name.toLowerCase().contains(lower)) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
