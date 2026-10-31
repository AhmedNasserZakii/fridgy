abstract class ApiKeys {
  static const String success = 'success';
  static const String message = 'message';
  static const String data = 'data';
  static const String errors = 'errors';
  static const String meta = 'meta';

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String expiresIn = 'expires_in';
  static const String user = 'user';

  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String avatarUrl = 'avatar_url';
  static const String profileCompleted = 'profile_completed';

  static const String foodCategories = 'food_categories';
  static const String diets = 'diets';
  static const String avoidIngredients = 'avoid_ingredients';
  static const String emoji = 'emoji';

  static const String householdSize = 'household_size';
  static const String favoriteFoodIds = 'favorite_food_ids';
  static const String dietId = 'diet_id';
  static const String avoidIngredientIds = 'avoid_ingredient_ids';
  static const String worksOut = 'works_out';
  static const String workoutFrequency = 'workout_frequency';
  static const String notificationsEnabled = 'notifications_enabled';

  // Food item / inventory
  static const String imageUrl = 'image_url';
  static const String category = 'category';
  static const String quantity = 'quantity';
  static const String unit = 'unit';
  static const String storage = 'storage';
  static const String purchaseDate = 'purchase_date';
  static const String isPartlyUsed = 'is_partly_used';
  static const String expiryDate = 'expiry_date';
  static const String daysLeft = 'days_left';
  static const String expiryStatus = 'expiry_status';
  static const String addedAt = 'added_at';

  // Pagination meta
  static const String page = 'page';
  static const String limit = 'limit';
  static const String total = 'total';
  static const String lastPage = 'last_page';
  static const String unreadCount = 'unread_count';

  // Home
  static const String kitchenSummary = 'kitchen_summary';
  static const String totalItems = 'total_items';
  static const String expiringSoonCount = 'expiring_soon_count';
  static const String unreadNotificationsCount = 'unread_notifications_count';
  static const String useFirst = 'use_first';
  static const String weeklyImpact = 'weekly_impact';
  static const String savedItemsCount = 'saved_items_count';
  static const String goalItemsCount = 'goal_items_count';
  static const String estimatedSavings = 'estimated_savings';
  static const String amount = 'amount';
  static const String currency = 'currency';
  static const String weekStart = 'week_start';
  static const String suggestion = 'suggestion';
  static const String title = 'title';
  static const String description = 'description';
  static const String recipeId = 'recipe_id';
  static const String usesItemIds = 'uses_item_ids';

  // Inventory query
  static const String q = 'q';
  static const String includeOutOfStock = 'include_out_of_stock';
  static const String sort = 'sort';
  static const String status = 'status';
  static const String expiresWithinDays = 'expires_within_days';

  // Notifications
  static const String type = 'type';
  static const String body = 'body';
  static const String isRead = 'is_read';
  static const String createdAt = 'created_at';
  static const String action = 'action';
  static const String updatedCount = 'updated_count';

  // Notification settings
  static const String osPermissionGranted = 'os_permission_granted';
  static const String expiryRemindersEnabled = 'expiry_reminders_enabled';
  static const String remindDaysBefore = 'remind_days_before';
  static const String reminderTime = 'reminder_time';
  static const String timezone = 'timezone';
  static const String shoppingListUpdates = 'shopping_list_updates';
  static const String householdActivity = 'household_activity';
  static const String weeklyImpactRecap = 'weekly_impact_recap';
}
