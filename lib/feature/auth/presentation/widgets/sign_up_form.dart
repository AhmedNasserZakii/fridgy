import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/app_validator.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/shared_widgets/app_text_field.dart';
import 'package:fridgy/feature/auth/presentation/widgets/terms_text.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.enabled,
    required this.fieldErrors,
    required this.onFieldChanged,
    required this.onSubmit,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool enabled;
  final Map<String, List<String>> fieldErrors;
  final ValueChanged<String> onFieldChanged;
  final VoidCallback onSubmit;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: LocaleKeys.fullName.tr(),
            hint: LocaleKeys.yourNameHint.tr(),
            controller: nameController,
            focusNode: nameFocus,
            suffixIcon: AppAssets.icUser,
            enabled: enabled,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            errorText: fieldErrors[ApiKeys.name]?.firstOrNull,
            validator: AppValidators.isValidName,
            onChanged: (_) => onFieldChanged(ApiKeys.name),
            onFieldSubmitted: (_) => emailFocus.requestFocus(),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: LocaleKeys.emailAddress.tr(),
            hint: LocaleKeys.enterYourEmailHint.tr(),
            controller: emailController,
            focusNode: emailFocus,
            suffixIcon: AppAssets.icMail,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            errorText: fieldErrors[ApiKeys.email]?.firstOrNull,
            validator: AppValidators.isValidEmail,
            onChanged: (_) => onFieldChanged(ApiKeys.email),
            onFieldSubmitted: (_) => passwordFocus.requestFocus(),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: LocaleKeys.password.tr(),
            hint: LocaleKeys.createPasswordHint.tr(),
            controller: passwordController,
            focusNode: passwordFocus,
            isPassword: true,
            enabled: enabled,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            errorText: fieldErrors[ApiKeys.password]?.firstOrNull,
            validator: AppValidators.isValidPassword,
            onChanged: (_) => onFieldChanged(ApiKeys.password),
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 16),
          const TermsText(),
        ],
      ),
    );
  }
}
