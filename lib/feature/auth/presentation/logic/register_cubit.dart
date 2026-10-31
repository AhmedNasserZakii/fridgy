import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/auth/domain/params/register_params.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/auth/presentation/logic/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this._authRepo}) : super(const RegisterInitial());

  final AuthRepo _authRepo;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(const RegisterLoading());

    final result = await _authRepo.register(
      RegisterParams(name: name, email: email, password: password),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        RegisterFailure(
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (user) => emit(RegisterSuccess(user)),
    );
  }
}
