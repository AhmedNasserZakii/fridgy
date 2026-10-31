import 'package:fridgy/core/network_services/mock/mock_response.dart';
import 'package:fridgy/core/network_services/web_constant.dart';

/// Registry of mock HTTP responses keyed by `'METHOD path'`.
///
/// Path keys may include `{param}` segments (e.g. `notifications/{id}/read`).
/// Query strings are stripped before matching (handled by [MockInterceptor]).
///
/// Switch a route to an error scenario while testing by setting
/// [overrides], e.g.:
/// ```dart
/// MockRoutes.overrides['GET ${WebConstant.home}'] = const MockResponse(
///   assetPath: 'assets/mocks/home/get_home_500.json',
///   statusCode: 500,
/// );
/// ```
abstract class MockRoutes {
  static final Map<String, MockResponse> overrides = {};

  static final Map<String, MockResponse> _defaults = {
    // Auth
    'POST ${WebConstant.register}': const MockResponse(
      assetPath: 'assets/mocks/auth/post_register.json',
      statusCode: 201,
    ),
    'POST ${WebConstant.login}': const MockResponse(
      assetPath: 'assets/mocks/auth/post_login.json',
    ),
    'POST ${WebConstant.refresh}': const MockResponse(
      assetPath: 'assets/mocks/auth/post_refresh.json',
    ),
    'POST ${WebConstant.logout}': const MockResponse(
      assetPath: 'assets/mocks/auth/post_logout.json',
    ),

    // Profile
    'GET ${WebConstant.setupOptions}': const MockResponse(
      assetPath: 'assets/mocks/profile/get_setup_options.json',
    ),
    'GET ${WebConstant.preferences}': const MockResponse(
      assetPath: 'assets/mocks/profile/get_preferences.json',
    ),
    'PUT ${WebConstant.preferences}': const MockResponse(
      assetPath: 'assets/mocks/profile/put_preferences.json',
    ),
    'PUT ${WebConstant.profile}': const MockResponse(
      assetPath: 'assets/mocks/profile/put_profile.json',
    ),

    // Home
    'GET ${WebConstant.home}': const MockResponse(
      assetPath: 'assets/mocks/home/get_home.json',
    ),

    // Inventory
    'GET ${WebConstant.inventory}': const MockResponse(
      assetPath: 'assets/mocks/inventory/get_inventory.json',
    ),
    'GET ${WebConstant.inventorySearch}': const MockResponse(
      assetPath: 'assets/mocks/inventory/get_search.json',
    ),
    'GET ${WebConstant.inventoryExpiring}': const MockResponse(
      assetPath: 'assets/mocks/inventory/get_expiring.json',
    ),
    'GET ${WebConstant.inventoryItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/inventory/get_inventory_item.json',
    ),
    'POST ${WebConstant.inventory}': const MockResponse(
      assetPath: 'assets/mocks/inventory/post_inventory.json',
      statusCode: 201,
    ),
    'PUT ${WebConstant.inventoryItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/inventory/put_inventory.json',
    ),
    'POST ${WebConstant.inventoryConsume('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/inventory/post_consume.json',
    ),

    // Notifications
    'GET ${WebConstant.notifications}': const MockResponse(
      assetPath: 'assets/mocks/notifications/get_notifications.json',
    ),
    'PATCH ${WebConstant.notificationRead('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/notifications/patch_read.json',
    ),
    'POST ${WebConstant.notificationsReadAll}': const MockResponse(
      assetPath: 'assets/mocks/notifications/post_read_all.json',
    ),

    // Notification settings (More tab)
    'GET ${WebConstant.notificationSettings}': const MockResponse(
      assetPath:
          'assets/mocks/notification_settings/get_notification_settings.json',
    ),
    'PUT ${WebConstant.notificationSettings}': const MockResponse(
      assetPath:
          'assets/mocks/notification_settings/put_notification_settings.json',
    ),
  };

  /// Named empty / error scenarios for manual testing.
  static const MockResponse refreshUnauthorized = MockResponse(
    assetPath: 'assets/mocks/auth/post_refresh_401.json',
    statusCode: 401,
  );
  static const MockResponse homeEmpty = MockResponse(
    assetPath: 'assets/mocks/home/get_home_empty.json',
  );
  static const MockResponse homeError = MockResponse(
    assetPath: 'assets/mocks/home/get_home_500.json',
    statusCode: 500,
  );
  static const MockResponse inventoryEmpty = MockResponse(
    assetPath: 'assets/mocks/inventory/get_inventory_empty.json',
  );
  static const MockResponse inventoryItem404 = MockResponse(
    assetPath: 'assets/mocks/inventory/get_inventory_item_404.json',
    statusCode: 404,
  );
  static const MockResponse inventoryCreate422 = MockResponse(
    assetPath: 'assets/mocks/inventory/post_inventory_422.json',
    statusCode: 422,
  );
  static const MockResponse inventoryUpdate422 = MockResponse(
    assetPath: 'assets/mocks/inventory/put_inventory_422.json',
    statusCode: 422,
  );
  static const MockResponse inventoryUpdate404 = MockResponse(
    assetPath: 'assets/mocks/inventory/put_inventory_404.json',
    statusCode: 404,
  );
  static const MockResponse inventoryConsume404 = MockResponse(
    assetPath: 'assets/mocks/inventory/post_consume_404.json',
    statusCode: 404,
  );
  static const MockResponse searchEmpty = MockResponse(
    assetPath: 'assets/mocks/inventory/get_search_empty.json',
  );
  static const MockResponse expiringEmpty = MockResponse(
    assetPath: 'assets/mocks/inventory/get_expiring_empty.json',
  );
  static const MockResponse notificationsEmpty = MockResponse(
    assetPath: 'assets/mocks/notifications/get_notifications_empty.json',
  );
  static const MockResponse notificationRead404 = MockResponse(
    assetPath: 'assets/mocks/notifications/patch_read_404.json',
    statusCode: 404,
  );
  static const MockResponse notificationSettingsValidation422 = MockResponse(
    assetPath:
        'assets/mocks/notification_settings/put_notification_settings_422.json',
    statusCode: 422,
  );

  static MockResponse? resolve(String method, String path) {
    final key = '${method.toUpperCase()} $path';
    final exact = overrides[key] ?? _defaults[key];
    if (exact != null) return exact;

    for (final entry in overrides.entries) {
      if (_matchesTemplate(entry.key, method, path)) return entry.value;
    }
    for (final entry in _defaults.entries) {
      if (_matchesTemplate(entry.key, method, path)) return entry.value;
    }
    return null;
  }

  static bool _matchesTemplate(String key, String method, String path) {
    final space = key.indexOf(' ');
    if (space < 0) return false;
    final keyMethod = key.substring(0, space);
    final template = key.substring(space + 1);
    if (keyMethod != method.toUpperCase()) return false;
    if (!template.contains('{')) return false;

    final templateParts = template.split('/');
    final pathParts = path.split('/');
    if (templateParts.length != pathParts.length) return false;

    for (var i = 0; i < templateParts.length; i++) {
      final part = templateParts[i];
      if (part.startsWith('{') && part.endsWith('}')) continue;
      if (part != pathParts[i]) return false;
    }
    return true;
  }
}
