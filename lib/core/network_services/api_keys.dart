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

  // Fridge AI
  static const String mode = 'mode';
  static const String conversationId = 'conversation_id';
  static const String userMessage = 'user_message';
  static const String assistantMessage = 'assistant_message';
  static const String replyKind = 'reply_kind';
  static const String proposedItems = 'proposed_items';
  static const String recipeSuggestions = 'recipe_suggestions';
  static const String proposedConsumptions = 'proposed_consumptions';
  static const String clarification = 'clarification';
  static const String targetItem = 'target_item';
  static const String quickReplies = 'quick_replies';
  static const String hint = 'hint';
  static const String note = 'note';
  static const String cancelLabel = 'cancel_label';
  static const String cancelMessage = 'cancel_message';
  static const String label = 'label';
  static const String role = 'role';
  static const String content = 'content';
  static const String image = 'image';
  static const String expiresAt = 'expires_at';
  static const String inventoryItemId = 'inventory_item_id';
  static const String preview = 'preview';
  static const String updatedAt = 'updated_at';
  static const String messages = 'messages';

  // Shopping
  static const String isChecked = 'is_checked';
  static const String catalogProductId = 'catalog_product_id';
  static const String notes = 'notes';
  static const String defaultQuantity = 'default_quantity';
  static const String defaultStorage = 'default_storage';
  static const String price = 'price';
  static const String unitPrice = 'unit_price';
  static const String lineTotal = 'line_total';
  static const String itemCount = 'item_count';
  static const String subtotal = 'subtotal';
  static const String lines = 'lines';
  static const String source = 'source';
  static const String sourceId = 'source_id';
  static const String items = 'items';
  static const String placedAt = 'placed_at';
  static const String receivedAt = 'received_at';
  static const String addedToFridgeAt = 'added_to_fridge_at';
  static const String intakeId = 'intake_id';
  static const String createdInventoryIds = 'created_inventory_ids';
  static const String createdCount = 'created_count';
}
