import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';

abstract class HomeRepo {
  Future<Either<ServerFailure, HomeDashboardEntity>> getDashboard();

  UserEntity? getCachedUser();
}
