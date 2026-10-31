import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  final EditProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool clearError = false,
    Map<String, List<String>>? fieldErrors,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, fieldErrors];
}
