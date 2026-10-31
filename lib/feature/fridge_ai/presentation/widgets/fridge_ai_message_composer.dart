import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_composer_icon_button.dart';

class FridgeAiMessageComposer extends StatelessWidget {
  const FridgeAiMessageComposer({
    required this.hint,
    required this.controller,
    required this.onAttachImage,
    required this.onMic,
    required this.onSend,
    this.focusNode,
    this.enabled = true,
    super.key,
  });

  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onAttachImage;
  final VoidCallback onMic;
  final VoidCallback onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsetsDirectional.fromSTEB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              style: AppTextStyles.bodyRegular16Primary,
              cursorColor: AppColors.brandPrimary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.bodyRegular16,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: enabled ? (_) => onSend() : null,
            ),
          ),
          const SizedBox(width: 6),
          FridgeAiComposerIconButton(
            background: AppColors.surfaceAccent,
            onTap: enabled ? onAttachImage : () {},
            child: SvgPicture.asset(
              AppAssets.icCamera,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.brandPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 6),
          FridgeAiComposerIconButton(
            background: AppColors.surfaceAccent,
            onTap: onMic,
            child: SvgPicture.asset(AppAssets.icMic, width: 22, height: 22),
          ),
          const SizedBox(width: 6),
          FridgeAiComposerIconButton(
            background: AppColors.brandPrimary,
            onTap: enabled ? onSend : () {},
            child: SvgPicture.asset(AppAssets.icArrowUp, width: 22, height: 22),
          ),
        ],
      ),
    );
  }
}
