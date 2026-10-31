import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileCompleted,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool profileCompleted;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      email: json[ApiKeys.email] as String,
      avatarUrl: json[ApiKeys.avatarUrl] as String?,
      profileCompleted: json[ApiKeys.profileCompleted] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.email: email,
      ApiKeys.avatarUrl: avatarUrl,
      ApiKeys.profileCompleted: profileCompleted,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      profileCompleted: profileCompleted,
    );
  }
}
