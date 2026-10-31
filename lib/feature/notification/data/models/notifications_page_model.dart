import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_model.dart';
import 'package:fridgy/feature/notification/data/models/notification_model.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';

class NotificationsPage {
  const NotificationsPage({
    required this.items,
    required this.meta,
    required this.unreadCount,
  });

  final List<NotificationEntity> items;
  final PaginationMeta meta;
  final int unreadCount;
}

class NotificationsPageModel {
  const NotificationsPageModel({
    required this.items,
    required this.meta,
    required this.unreadCount,
  });

  final List<NotificationModel> items;
  final PaginationMetaModel meta;
  final int unreadCount;

  factory NotificationsPageModel.fromJson({
    required List<dynamic> data,
    required Map<String, dynamic> meta,
  }) {
    return NotificationsPageModel(
      items: data
          .whereType<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList(),
      meta: PaginationMetaModel.fromJson(meta),
      unreadCount: meta[ApiKeys.unreadCount] as int? ?? 0,
    );
  }

  NotificationsPage toEntity() {
    return NotificationsPage(
      items: items.map((e) => e.toEntity()).toList(),
      meta: meta.toEntity(),
      unreadCount: unreadCount,
    );
  }
}
