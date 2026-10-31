import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/auth/domain/params/register_params.dart';

class RegisterRequestModel {
  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  factory RegisterRequestModel.fromParams(RegisterParams params) {
    return RegisterRequestModel(
      name: params.name.trim(),
      email: params.email.trim(),
      password: params.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: name,
      ApiKeys.email: email,
      ApiKeys.password: password,
    };
  }
}
