import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/auth/domain/params/login_params.dart';
import 'package:fridgy/feature/auth/domain/params/register_params.dart';

abstract class AuthRepo {
  Future<Either<ServerFailure, UserEntity>> register(RegisterParams params);

  Future<Either<ServerFailure, UserEntity>> login(LoginParams params);

  Future<Either<ServerFailure, Unit>> logout();

  String? getLastUserName();

  Future<bool> hasAccessToken();

  UserEntity? getCachedUser();
}
