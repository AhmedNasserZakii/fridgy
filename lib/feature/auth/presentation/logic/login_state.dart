import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  const LoginFailure({required this.message, this.fieldErrors = const {}});

  final String message;
  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}
