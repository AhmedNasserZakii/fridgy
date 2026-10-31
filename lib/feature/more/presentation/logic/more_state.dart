import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';

class MoreState extends Equatable {
  const MoreState({
    this.user,
    this.isSigningOut = false,
    this.signedOut = false,
  });

  final UserEntity? user;
  final bool isSigningOut;
  final bool signedOut;

  MoreState copyWith({UserEntity? user, bool? isSigningOut, bool? signedOut}) {
    return MoreState(
      user: user ?? this.user,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      signedOut: signedOut ?? this.signedOut,
    );
  }

  @override
  List<Object?> get props => [user, isSigningOut, signedOut];
}
