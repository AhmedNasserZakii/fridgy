import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/more/domain/entities/notification_settings_entity.dart';
import 'package:fridgy/feature/more/domain/params/update_notification_settings_params.dart';

abstract class NotificationSettingsRepo {
  Future<Either<ServerFailure, NotificationSettingsEntity>>
  getNotificationSettings();

  Future<Either<ServerFailure, NotificationSettingsEntity>>
  updateNotificationSettings(UpdateNotificationSettingsParams params);
}
