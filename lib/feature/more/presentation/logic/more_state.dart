import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

class MoreState extends Equatable {
  const MoreState({
    this.user,
    this.isSigningOut = false,
    this.signedOut = false,
    this.apiModeSwitched = false,
  });

  final UserEntity? user;
  final bool isSigningOut;
  final bool signedOut;

  /// True when the sign-out was caused by switching local/live API mode.
  final bool apiModeSwitched;

  MoreState copyWith({
    UserEntity? user,
    bool? isSigningOut,
    bool? signedOut,
    bool? apiModeSwitched,
  }) {
    return MoreState(
      user: user ?? this.user,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      signedOut: signedOut ?? this.signedOut,
      apiModeSwitched: apiModeSwitched ?? this.apiModeSwitched,
    );
  }

  @override
  List<Object?> get props => [user, isSigningOut, signedOut, apiModeSwitched];
}
