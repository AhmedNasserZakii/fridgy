import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/auth/presentation/logic/login_cubit.dart';
import 'package:fridgy/feature/auth/presentation/logic/login_state.dart';
import 'package:fridgy/feature/auth/presentation/widgets/auth_intro_text.dart';
import 'package:fridgy/feature/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:fridgy/feature/auth/presentation/widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final Map<String, List<String>> _fieldErrors = {};
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    context.read<LoginCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  void _clearFieldError(String field) {
    if (!_fieldErrors.containsKey(field)) return;
    setState(() => _fieldErrors.remove(field));
  }

  String _welcomeHeadline(LoginCubit cubit) {
    final name = cubit.lastUserName;
    if (name == null || name.isEmpty) {
      return LocaleKeys.welcomeBack.tr();
    }
    final firstName = name.trim().split(RegExp(r'\s+')).first;
    return LocaleKeys.welcomeBackNamed.tr(args: [firstName]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          setState(() {
            _fieldErrors
              ..clear()
              ..addAll(state.fieldErrors);
          });
          if (state.fieldErrors.isEmpty) {
            AppSnackBar.show(context, state.message);
          }
        } else if (state is LoginSuccess) {
          if (state.user.profileCompleted) {
            AppRoute.openMainApp(Navigator.of(context));
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.profileSetup,
              (_) => false,
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final cubit = context.read<LoginCubit>();

        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(title: LocaleKeys.signIn.tr()),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthIntroText(
                          headline: _welcomeHeadline(cubit),
                          subtitle: LocaleKeys.welcomeBackSubtitle.tr(),
                          useLargeTitleHeight: true,
                        ),
                        const SizedBox(height: 40),
                        SignInForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailFocus: _emailFocus,
                          passwordFocus: _passwordFocus,
                          enabled: !isLoading,
                          fieldErrors: _fieldErrors,
                          onFieldChanged: _clearFieldError,
                          onSubmit: _submit,
                          autovalidateMode: _autovalidateMode,
                        ),
                      ],
                    ),
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: LocaleKeys.signIn.tr(),
                  onPrimaryPressed: isLoading ? null : _submit,
                  isPrimaryLoading: isLoading,
                  secondaryChild: AuthSwitchPrompt(
                    leading: LocaleKeys.newToFridgy.tr(),
                    actionLabel: LocaleKeys.createAccount.tr(),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoute.signUp);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
