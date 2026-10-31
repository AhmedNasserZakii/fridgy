import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

abstract class MoreRepo {
  Future<Either<ServerFailure, UserEntity>> updateProfile({
    required String name,
    required String email,
  });
}
