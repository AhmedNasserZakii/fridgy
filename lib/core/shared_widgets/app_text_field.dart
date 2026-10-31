import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.isPassword = false,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? suffixIcon;
  final bool isPassword;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError ? AppColors.error : AppColors.borderInput;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.fieldLabelSemiBold14),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          style: AppTextStyles.fieldValueRegular14,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.fieldHintRegular14,
            filled: true,
            fillColor: AppColors.surfaceDefault,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: _buildSuffix(),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.brandPrimary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderInput),
            ),
            errorStyle: AppTextStyles.errorCaptionRegular12,
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: SvgPicture.asset(
          _obscure ? AppAssets.icEyeOff : AppAssets.icEye,
          width: 19,
          height: 19,
        ),
      );
    }

    if (widget.suffixIcon == null) return null;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16),
      child: SvgPicture.asset(widget.suffixIcon!, width: 19, height: 19),
    );
  }
}
