import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/notification/data/models/notifications_page_model.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepo {
  Future<Either<ServerFailure, NotificationsPage>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<Either<ServerFailure, NotificationEntity>> markRead(String id);

  Future<Either<ServerFailure, int>> markAllRead();
}
