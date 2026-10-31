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

    // Fridge AI
    'POST ${WebConstant.fridgeAiMessages}': const MockResponse(
      assetPath: 'assets/mocks/fridge_ai/post_messages_add_food.json',
    ),
    'POST ${WebConstant.fridgeAiMessagesImage}': const MockResponse(
      assetPath: 'assets/mocks/fridge_ai/post_messages_image.json',
    ),
    'GET ${WebConstant.fridgeAiConversations}': const MockResponse(
      assetPath: 'assets/mocks/fridge_ai/get_conversations.json',
    ),
    'GET ${WebConstant.fridgeAiConversationMessages('{id}')}':
        const MockResponse(
      assetPath: 'assets/mocks/fridge_ai/get_conversation_messages.json',
    ),

    // Shopping — list
    'GET ${WebConstant.shoppingList}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_list.json',
    ),
    'POST ${WebConstant.shoppingList}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_list.json',
      statusCode: 201,
    ),
    'PUT ${WebConstant.shoppingListItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/put_list_item.json',
    ),
    'DELETE ${WebConstant.shoppingListItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/delete_list_item.json',
    ),
    'POST ${WebConstant.shoppingListToggle('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_list_toggle.json',
    ),
    'POST ${WebConstant.shoppingListComplete}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_list_complete.json',
    ),

    // Shopping — catalog
    'GET ${WebConstant.shoppingCatalog}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_catalog.json',
    ),
    'GET ${WebConstant.shoppingCatalogProduct('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_catalog_product.json',
    ),

    // Shopping — cart
    'GET ${WebConstant.shoppingCart}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_cart.json',
    ),
    'POST ${WebConstant.shoppingCartItems}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_cart_item.json',
      statusCode: 201,
    ),
    'PUT ${WebConstant.shoppingCartItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/put_cart_item.json',
    ),
    'DELETE ${WebConstant.shoppingCartItem('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/delete_cart_item.json',
    ),
    'DELETE ${WebConstant.shoppingCart}': const MockResponse(
      assetPath: 'assets/mocks/shopping/delete_cart.json',
    ),

    // Shopping — orders + fridge intake
    'POST ${WebConstant.shoppingOrders}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_order.json',
      statusCode: 201,
    ),
    'GET ${WebConstant.shoppingOrders}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_orders.json',
    ),
    'GET ${WebConstant.shoppingOrder('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/get_order.json',
    ),
    'POST ${WebConstant.shoppingOrderComplete('{id}')}': const MockResponse(
      assetPath: 'assets/mocks/shopping/post_order_complete.json',
    ),
    'POST ${WebConstant.shoppingFridgeIntakeConfirm('{id}')}':
        const MockResponse(
      assetPath: 'assets/mocks/shopping/post_fridge_intake_confirm.json',
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
  static const MockResponse fridgeAiMessagesAddFood = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_add_food.json',
  );
  static const MockResponse fridgeAiMessagesUseFood = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_use_food.json',
  );
  static const MockResponse fridgeAiMessagesClarification = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_clarification.json',
  );
  static const MockResponse fridgeAiMessagesImage = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_image.json',
  );
  static const MockResponse fridgeAiMessagesImage422 = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_image_422.json',
    statusCode: 422,
  );
  static const MockResponse fridgeAiMessages422 = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_422.json',
    statusCode: 422,
  );
  static const MockResponse fridgeAiMessages429 = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_429.json',
    statusCode: 429,
  );
  static const MockResponse fridgeAiMessages503 = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/post_messages_503.json',
    statusCode: 503,
  );
  static const MockResponse fridgeAiConversationsEmpty = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/get_conversations_empty.json',
  );
  static const MockResponse fridgeAiConversationMessages404 = MockResponse(
    assetPath: 'assets/mocks/fridge_ai/get_conversation_messages_404.json',
    statusCode: 404,
  );
  static const MockResponse shoppingListEmpty = MockResponse(
    assetPath: 'assets/mocks/shopping/get_list_empty.json',
  );
  static const MockResponse shoppingListCreate422 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_list_422.json',
    statusCode: 422,
  );
  static const MockResponse shoppingListComplete422 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_list_complete_422.json',
    statusCode: 422,
  );
  static const MockResponse shoppingCatalogEmpty = MockResponse(
    assetPath: 'assets/mocks/shopping/get_catalog_empty.json',
  );
  static const MockResponse shoppingCatalogProduct404 = MockResponse(
    assetPath: 'assets/mocks/shopping/get_catalog_product_404.json',
    statusCode: 404,
  );
  static const MockResponse shoppingCartEmpty = MockResponse(
    assetPath: 'assets/mocks/shopping/get_cart_empty.json',
  );
  static const MockResponse shoppingOrder422 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_order_422.json',
    statusCode: 422,
  );
  static const MockResponse shoppingOrdersEmpty = MockResponse(
    assetPath: 'assets/mocks/shopping/get_orders_empty.json',
  );
  static const MockResponse shoppingOrder404 = MockResponse(
    assetPath: 'assets/mocks/shopping/get_order_404.json',
    statusCode: 404,
  );
  static const MockResponse shoppingOrderComplete409 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_order_complete_409.json',
    statusCode: 409,
  );
  static const MockResponse shoppingFridgeIntakeConfirm422 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_fridge_intake_confirm_422.json',
    statusCode: 422,
  );
  static const MockResponse shoppingFridgeIntakeConfirm404 = MockResponse(
    assetPath: 'assets/mocks/shopping/post_fridge_intake_confirm_404.json',
    statusCode: 404,
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
