import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fridgy/feature/home/data/models/home_dashboard_model.dart';
import 'package:fridgy/feature/inventory/data/models/food_item_model.dart';
import 'package:fridgy/feature/notification/data/models/notifications_page_model.dart';

void main() {
  Map<String, dynamic> loadMock(String relativePath) {
    final file = File(relativePath);
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  test('parses get_home.json', () {
    final body = loadMock('assets/mocks/home/get_home.json');
    final model = HomeDashboardModel.fromJson(
      body['data'] as Map<String, dynamic>,
    );
    final entity = model.toEntity();
    expect(entity.totalItems, 24);
    expect(entity.expiringSoonCount, 5);
    expect(entity.unreadNotificationsCount, 3);
    expect(entity.useFirst, hasLength(3));
    expect(entity.useFirst.last.name, 'Fresh Milk');
    expect(entity.useFirst.last.id, 'itm_4d90');
    expect(entity.weeklyImpact?.savedItemsCount, 8);
    expect(entity.weeklyImpact?.estimatedSavings.display, 'EGP 420');
    expect(entity.suggestion?.id, 'sug_3e7b');
  });

  test('parses get_home_empty.json with nulls', () {
    final body = loadMock('assets/mocks/home/get_home_empty.json');
    final entity = HomeDashboardModel.fromJson(
      body['data'] as Map<String, dynamic>,
    ).toEntity();
    expect(entity.totalItems, 0);
    expect(entity.useFirst, isEmpty);
    expect(entity.weeklyImpact, isNull);
    expect(entity.suggestion, isNull);
  });

  test('parses get_search.json food items', () {
    final body = loadMock('assets/mocks/inventory/get_search.json');
    final data = body['data'] as List<dynamic>;
    final items = data
        .whereType<Map<String, dynamic>>()
        .map(FoodItemModel.fromJson)
        .map((m) => m.toEntity())
        .toList();
    expect(items, hasLength(2));
    expect(items.first.name, 'Fresh Milk');
    expect(items.first.isPartlyUsed, isTrue);
    expect(items.last.name, 'Minced Beef');
  });

  test('parses get_notifications.json with unread_count', () {
    final body = loadMock('assets/mocks/notifications/get_notifications.json');
    final page = NotificationsPageModel.fromJson(
      data: body['data'] as List<dynamic>,
      meta: body['meta'] as Map<String, dynamic>,
    ).toEntity();
    expect(page.items, hasLength(4));
    expect(page.unreadCount, 3);
    expect(page.meta.total, 4);
  });
}
