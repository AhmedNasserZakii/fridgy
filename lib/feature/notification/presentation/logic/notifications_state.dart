import 'package:equatable/equatable.dart';
import 'package:fridgy/core/network_services/models/pagination_meta_entity.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/presentation/logic/notification_group.dart';

enum NotificationsStatus { loading, loadingMore, success, empty, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.loading,
    this.items = const [],
    this.groups = const [],
    this.meta,
    this.unreadCount = 0,
    this.message,
    this.messageId = 0,
  });

  final NotificationsStatus status;
  final List<NotificationEntity> items;
  final List<NotificationGroup> groups;
  final PaginationMeta? meta;
  final int unreadCount;

  /// Transient error message for optimistic-update rollbacks (D11/D12),
  /// surfaced once via [messageId] changes.
  final String? message;
  final int messageId;

  bool get hasMore => meta?.hasMore ?? false;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? items,
    List<NotificationGroup>? groups,
    PaginationMeta? meta,
    int? unreadCount,
    String? message,
    int? messageId,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      groups: groups ?? this.groups,
      meta: meta ?? this.meta,
      unreadCount: unreadCount ?? this.unreadCount,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    groups,
    meta,
    unreadCount,
    message,
    messageId,
  ];
}
