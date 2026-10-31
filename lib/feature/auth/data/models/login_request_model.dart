import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/auth/domain/params/login_params.dart';

class LoginRequestModel {
  const LoginRequestModel({required this.email, required this.password});

  final String email;
  final String password;

  factory LoginRequestModel.fromParams(LoginParams params) {
    return LoginRequestModel(
      email: params.email.trim(),
      password: params.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiKeys.email: email, ApiKeys.password: password};
  }
}
