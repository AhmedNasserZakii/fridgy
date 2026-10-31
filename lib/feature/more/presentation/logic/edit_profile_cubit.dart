import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/more/domain/repos/more_repo.dart';
import 'package:fridgy/feature/more/presentation/logic/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required this._moreRepo, required AuthRepo authRepo})
    : super(EditProfileState(user: authRepo.getCachedUser()));

  final MoreRepo _moreRepo;

  Future<void> save({required String name, required String email}) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: EditProfileStatus.loading,
        clearError: true,
        fieldErrors: const {},
      ),
    );

    final result = await _moreRepo.updateProfile(name: name, email: email);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: EditProfileStatus.success,
          user: user,
          clearError: true,
          fieldErrors: const {},
        ),
      ),
    );
  }

  void clearFieldError(String field) {
    if (!state.fieldErrors.containsKey(field)) return;
    final next = Map<String, List<String>>.from(state.fieldErrors)
      ..remove(field);
    emit(state.copyWith(fieldErrors: next));
  }
}
