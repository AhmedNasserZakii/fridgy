import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/notification/data/models/notification_action_model.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_type.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.imageUrl,
    this.action,
  });

  final String id;
  final NotificationType? type;
  final String title;
  final String body;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;
  final NotificationActionModel? action;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final actionRaw = json[ApiKeys.action];
    return NotificationModel(
      id: json[ApiKeys.id] as String,
      type: NotificationType.fromJson(json[ApiKeys.type] as String?),
      title: json[ApiKeys.title] as String,
      body: json[ApiKeys.body] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      isRead: json[ApiKeys.isRead] as bool,
      createdAt: DateTime.parse(json[ApiKeys.createdAt] as String),
      action: NotificationActionModel.tryFromJson(
        actionRaw is Map<String, dynamic> ? actionRaw : null,
      ),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      isRead: isRead,
      createdAt: createdAt,
      action: action?.toEntity(),
    );
  }
}
