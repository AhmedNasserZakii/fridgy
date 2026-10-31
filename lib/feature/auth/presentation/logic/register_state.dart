import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure({required this.message, this.fieldErrors = const {}});

  final String message;
  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}
