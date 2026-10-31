import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/app_validator.dart';
import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/app_text_field.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/logic/edit_profile_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/edit_profile_state.dart';
import 'package:fridgy/feature/more/presentation/logic/more_cubit.dart';
import 'package:fridgy/feature/more/presentation/widgets/context_guidance_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = context.read<EditProfileCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<EditProfileCubit>().save(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditProfileStatus.success) {
          AppSnackBar.show(context, LocaleKeys.profileSaved.tr());
          Navigator.of(context).pop();
          return;
        }
        if (state.status == EditProfileStatus.failure &&
            state.fieldErrors.isEmpty &&
            state.errorMessage != null) {
          AppSnackBar.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final loading = state.status == EditProfileStatus.loading;
        final name = state.user?.name ?? _nameController.text;

        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(title: LocaleKeys.editProfile.tr()),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              MoreCubit.initialsFor(name),
                              style: AppTextStyles.titleBold26.copyWith(
                                color: AppColors.brandPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () => AppSnackBar.show(
                              context,
                              LocaleKeys.comingSoon.tr(),
                            ),
                            child: Text(
                              LocaleKeys.changePhoto.tr(),
                              style: AppTextStyles.secondaryBodySemiBold14Brand,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: LocaleKeys.fullName.tr(),
                          hint: LocaleKeys.yourNameHint.tr(),
                          controller: _nameController,
                          enabled: !loading,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.isValidName,
                          errorText: state.fieldErrors[ApiKeys.name]?.first,
                          onChanged: (_) => context
                              .read<EditProfileCubit>()
                              .clearFieldError(ApiKeys.name),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: LocaleKeys.emailAddress.tr(),
                          hint: LocaleKeys.enterYourEmailHint.tr(),
                          controller: _emailController,
                          enabled: !loading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: AppValidators.isValidEmail,
                          errorText: state.fieldErrors[ApiKeys.email]?.first,
                          onChanged: (_) => context
                              .read<EditProfileCubit>()
                              .clearFieldError(ApiKeys.email),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 16),
                        ContextGuidanceBox(
                          message: LocaleKeys.profilePrivacyNote.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: LocaleKeys.saveChanges.tr(),
                  onPrimaryPressed: loading ? null : _submit,
                  isPrimaryLoading: loading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
