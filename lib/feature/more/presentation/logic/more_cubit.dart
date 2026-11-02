import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/network_services/api_mode_controller.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/more/presentation/logic/more_state.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit({required AuthRepo authRepo, required this._apiModeController})
    : _authRepo = authRepo,
      super(MoreState(user: authRepo.getCachedUser()));

  final AuthRepo _authRepo;
  final ApiModeController _apiModeController;

  void refreshUser() {
    if (isClosed) return;
    emit(state.copyWith(user: _authRepo.getCachedUser()));
  }

  Future<void> signOut() async {
    if (isClosed || state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true));
    await _authRepo.logout();
    if (isClosed) return;
    emit(state.copyWith(isSigningOut: false, signedOut: true));
  }

  /// Signs out against the current data source, then switches, so a session
  /// from local mocks is never sent to the live API (or the reverse).
  Future<void> switchApiMode(ApiMode mode) async {
    if (isClosed || state.isSigningOut) return;
    if (_apiModeController.mode == mode) return;
    emit(state.copyWith(isSigningOut: true));
    await _authRepo.logout();
    await _apiModeController.setMode(mode);
    if (isClosed) return;
    emit(
      state.copyWith(
        isSigningOut: false,
        signedOut: true,
        apiModeSwitched: true,
      ),
    );
  }

  static String initialsFor(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final value = parts.first;
      return value.substring(0, value.length >= 2 ? 2 : 1).toUpperCase();
    }
    return ('${parts.first[0]}${parts[1][0]}').toUpperCase();
  }
}
