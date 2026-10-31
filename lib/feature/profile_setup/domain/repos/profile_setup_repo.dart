import 'package:dartz/dartz.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/setup_options_entity.dart';
import 'package:fridgy/feature/profile_setup/domain/params/profile_preferences_params.dart';

abstract class ProfileSetupRepo {
  Future<Either<ServerFailure, SetupOptionsEntity>> getSetupOptions();

  Future<Either<ServerFailure, ProfilePreferencesParams>> getPreferences();

  Future<Either<ServerFailure, UserEntity>> savePreferences(
    ProfilePreferencesParams params,
  );
}
