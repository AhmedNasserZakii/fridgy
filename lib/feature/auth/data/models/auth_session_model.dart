import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/auth/data/models/user_model.dart';
import 'package:fridgy/feature/auth/domain/entities/auth_session_entity.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json[ApiKeys.accessToken] as String,
      refreshToken: json[ApiKeys.refreshToken] as String,
      expiresIn: json[ApiKeys.expiresIn] as int,
      user: UserModel.fromJson(json[ApiKeys.user] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.accessToken: accessToken,
      ApiKeys.refreshToken: refreshToken,
      ApiKeys.expiresIn: expiresIn,
      ApiKeys.user: user.toJson(),
    };
  }

  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      user: user.toEntity(),
    );
  }
}
