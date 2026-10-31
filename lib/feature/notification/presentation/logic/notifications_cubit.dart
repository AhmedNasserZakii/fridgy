import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/domain/repos/notification_repo.dart';
import 'package:fridgy/feature/notification/presentation/logic/notification_group.dart';
import 'package:fridgy/feature/notification/presentation/logic/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required this._notificationRepo})
    : super(const NotificationsState()) {
    load();
  }

  final NotificationRepo _notificationRepo;

  static const int _pageSize = 20;

  Future<void> load() async {
    if (isClosed) return;
    emit(state.copyWith(status: NotificationsStatus.loading));
    await _fetchFirstPage();
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> _fetchFirstPage() async {
    final result = await _notificationRepo.getNotifications(
      page: 1,
      limit: _pageSize,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          message: failure.message,
          messageId: state.messageId + 1,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: page.items.isEmpty
              ? NotificationsStatus.empty
              : NotificationsStatus.success,
          items: page.items,
          groups: _group(page.items),
          meta: page.meta,
          unreadCount: page.unreadCount,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.status != NotificationsStatus.success || !state.hasMore) return;
    final meta = state.meta;
    if (meta == null) return;

    emit(state.copyWith(status: NotificationsStatus.loadingMore));
    final result = await _notificationRepo.getNotifications(
      page: meta.page + 1,
      limit: _pageSize,
    );
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(status: NotificationsStatus.success)),
      (page) {
        final merged = [...state.items, ...page.items];
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            items: merged,
            groups: _group(merged),
            meta: page.meta,
            unreadCount: page.unreadCount,
          ),
        );
      },
    );
  }

  /// Optimistically mark one notification read, rolling back on failure (D11).
  Future<void> markRead(String id) async {
    final index = state.items.indexWhere((n) => n.id == id);
    if (index < 0) return;
    if (state.items[index].isRead) return;

    final previousItems = state.items;
    final previousUnread = state.unreadCount;

    final updated = [...previousItems];
    updated[index] = updated[index].copyWith(isRead: true);
    emit(
      state.copyWith(
        items: updated,
        groups: _group(updated),
        unreadCount: (previousUnread - 1).clamp(0, previousUnread),
      ),
    );

    final result = await _notificationRepo.markRead(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          items: previousItems,
          groups: _group(previousItems),
          unreadCount: previousUnread,
          message: failure.message,
          messageId: state.messageId + 1,
        ),
      ),
      (_) {},
    );
  }

  /// Optimistically mark everything read, rolling back on failure (D12).
  Future<void> markAllRead() async {
    if (state.unreadCount == 0) return;

    final previousItems = state.items;
    final previousUnread = state.unreadCount;

    final updated = previousItems
        .map((n) => n.isRead ? n : n.copyWith(isRead: true))
        .toList();
    emit(
      state.copyWith(items: updated, groups: _group(updated), unreadCount: 0),
    );

    final result = await _notificationRepo.markAllRead();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          items: previousItems,
          groups: _group(previousItems),
          unreadCount: previousUnread,
          message: failure.message,
          messageId: state.messageId + 1,
        ),
      ),
      (_) {},
    );
  }

  /// Skeleton-only layout data — never shown as real content.
  static List<NotificationEntity> skeletonItems() {
    final now = DateTime.now().toUtc();
    NotificationEntity fake(String id) => NotificationEntity(
      id: 'skeleton_$id',
      title: 'Notification title here',
      body: 'Short supporting notification body text',
      isRead: false,
      createdAt: now,
    );
    return [fake('1'), fake('2'), fake('3')];
  }

  /// Groups notifications by their local calendar date, newest first (D10).
  List<NotificationGroup> _group(List<NotificationEntity> items) {
    final buckets = <DateTime, List<NotificationEntity>>{};
    for (final item in items) {
      final local = item.createdAt.toLocal();
      final key = DateTime(local.year, local.month, local.day);
      (buckets[key] ??= <NotificationEntity>[]).add(item);
    }
    final keys = buckets.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final key in keys)
        NotificationGroup(date: key, items: buckets[key]!),
    ];
  }
}
