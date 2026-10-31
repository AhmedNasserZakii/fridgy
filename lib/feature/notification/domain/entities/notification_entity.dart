import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_action.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_type.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
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
  final NotificationAction? action;

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      action: action,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    imageUrl,
    isRead,
    createdAt,
    action,
  ];
}
