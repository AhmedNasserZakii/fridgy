import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/auth/domain/params/login_params.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/auth/presentation/logic/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this._authRepo}) : super(const LoginInitial());

  final AuthRepo _authRepo;

  String? get lastUserName => _authRepo.getLastUserName();

  Future<void> login({required String email, required String password}) async {
    if (isClosed) return;
    emit(const LoginLoading());

    final result = await _authRepo.login(
      LoginParams(email: email, password: password),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        LoginFailure(
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      ),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
