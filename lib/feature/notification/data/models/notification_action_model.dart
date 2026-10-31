import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_action.dart';

class NotificationActionModel {
  const NotificationActionModel({required this.type, required this.id});

  final NotificationActionType type;
  final String id;

  static NotificationActionModel? tryFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final type = NotificationActionType.fromJson(json[ApiKeys.type] as String?);
    final id = json[ApiKeys.id] as String?;
    if (type == null || id == null) return null;
    return NotificationActionModel(type: type, id: id);
  }

  NotificationAction toEntity() => NotificationAction(type: type, id: id);
}
