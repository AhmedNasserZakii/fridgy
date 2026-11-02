abstract class WebConstant {
  static const String baseUrl =
      'https://api.fridgy.easytechsolutions.site/api/v1/';

  /// Shows the Local data / Live API switch on the Welcome and More screens.
  /// Set to false before a store release.
  static const bool showApiModeToggle = true;

  // Local mocks vs live API is chosen at runtime by ApiModeController.

  // Auth
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String refresh = 'auth/refresh';
  static const String logout = 'auth/logout';

  // Profile setup
  static const String setupOptions = 'profile/setup-options';
  static const String preferences = 'profile/preferences';
  static const String profile = 'profile';

  // Notification settings (More tab)
  static const String notificationSettings = 'notification-settings';

  // Home
  static const String home = 'home';

  // Inventory
  static const String inventory = 'inventory';
  static const String inventorySearch = 'inventory/search';
  static const String inventoryExpiring = 'inventory/expiring';
  static String inventoryItem(String id) => 'inventory/$id';
  static String inventoryConsume(String id) => 'inventory/$id/consume';

  // Notifications
  static const String notifications = 'notifications';
  static const String notificationsReadAll = 'notifications/read-all';
  static String notificationRead(String id) => 'notifications/$id/read';

  // Fridge AI
  static const String fridgeAiMessages = 'fridge-ai/messages';
  static const String fridgeAiMessagesImage = 'fridge-ai/messages/image';
  static const String fridgeAiConversations = 'fridge-ai/conversations';
  static String fridgeAiConversationMessages(String id) =>
      'fridge-ai/conversations/$id/messages';

  // Shopping
  static const String shoppingList = 'shopping/list';
  static String shoppingListItem(String id) => 'shopping/list/$id';
  static String shoppingListToggle(String id) => 'shopping/list/$id/toggle';
  static const String shoppingListComplete = 'shopping/list/complete';
  static const String shoppingCatalog = 'shopping/catalog';
  static String shoppingCatalogProduct(String id) => 'shopping/catalog/$id';
  static const String shoppingCart = 'shopping/cart';
  static const String shoppingCartItems = 'shopping/cart/items';
  static String shoppingCartItem(String id) => 'shopping/cart/items/$id';
  static const String shoppingOrders = 'shopping/orders';
  static String shoppingOrder(String id) => 'shopping/orders/$id';
  static String shoppingOrderComplete(String id) =>
      'shopping/orders/$id/complete';
  static String shoppingFridgeIntakeConfirm(String id) =>
      'shopping/fridge-intake/$id/confirm';
}
