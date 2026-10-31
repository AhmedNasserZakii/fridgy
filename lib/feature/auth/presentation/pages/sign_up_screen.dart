import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/auth/presentation/logic/register_cubit.dart';
import 'package:fridgy/feature/auth/presentation/logic/register_state.dart';
import 'package:fridgy/feature/auth/presentation/widgets/auth_intro_text.dart';
import 'package:fridgy/feature/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:fridgy/feature/auth/presentation/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final Map<String, List<String>> _fieldErrors = {};
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    context.read<RegisterCubit>().register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _clearFieldError(String field) {
    if (!_fieldErrors.containsKey(field)) return;
    setState(() => _fieldErrors.remove(field));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          setState(() {
            _fieldErrors
              ..clear()
              ..addAll(state.fieldErrors);
          });
          if (state.fieldErrors.isEmpty) {
            AppSnackBar.show(context, state.message);
          }
        } else if (state is RegisterSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.profileSetup, (_) => false);
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;

        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(title: LocaleKeys.signUp.tr()),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthIntroText(
                          headline: LocaleKeys.aFresherStart.tr(),
                          subtitle: LocaleKeys.aFresherStartSubtitle.tr(),
                        ),
                        const SizedBox(height: 40),
                        SignUpForm(
                          formKey: _formKey,
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          nameFocus: _nameFocus,
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
                  primaryLabel: LocaleKeys.createAccount.tr(),
                  onPrimaryPressed: isLoading ? null : _submit,
                  isPrimaryLoading: isLoading,
                  secondaryChild: AuthSwitchPrompt(
                    leading: LocaleKeys.alreadyHaveAccount.tr(),
                    actionLabel: LocaleKeys.signIn.tr(),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoute.signIn);
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
