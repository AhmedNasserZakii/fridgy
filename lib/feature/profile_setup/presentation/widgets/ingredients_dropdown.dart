import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/bottom_sheet_widgets/multi_select_bottom_sheet.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/option_entity.dart';

class IngredientsDropdown extends StatelessWidget {
  const IngredientsDropdown({
    super.key,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
  });

  final List<OptionEntity> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showMultiSelectBottomSheet(
      context: context,
      title: LocaleKeys.avoidIngredientsQuestion.tr(),
      options: options,
      initiallySelected: selectedIds,
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final label = selectedIds.isEmpty
        ? LocaleKeys.avoidIngredientsHint.tr()
        : options
              .where((o) => selectedIds.contains(o.id))
              .map((o) => o.name)
              .join(', ');

    return Material(
      color: AppColors.surfaceDefault,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderInput),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: selectedIds.isEmpty
                      ? AppTextStyles.fieldHintRegular14
                      : AppTextStyles.fieldValueRegular14,
                ),
              ),
              SvgPicture.asset(
                AppAssets.icChevronDown,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.textHint,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
