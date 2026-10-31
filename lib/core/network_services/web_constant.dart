abstract class WebConstant {
  static const String baseUrl = 'https://api.fridgy.app/api/v1/';
  static const bool useMocks = true;

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
}
