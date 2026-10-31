import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

class AuthSessionEntity extends Equatable {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserEntity user;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, user];
}
