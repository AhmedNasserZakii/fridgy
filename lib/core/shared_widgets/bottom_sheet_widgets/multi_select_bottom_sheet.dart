import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/profile_setup/domain/entities/option_entity.dart';

Future<Set<String>?> showMultiSelectBottomSheet({
  required BuildContext context,
  required String title,
  required List<OptionEntity> options,
  required Set<String> initiallySelected,
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surfaceDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return MultiSelectBottomSheet(
        title: title,
        options: options,
        initiallySelected: initiallySelected,
      );
    },
  );
}

class MultiSelectBottomSheet extends StatefulWidget {
  const MultiSelectBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initiallySelected,
  });

  final String title;
  final List<OptionEntity> options;
  final Set<String> initiallySelected;

  @override
  State<MultiSelectBottomSheet> createState() => _MultiSelectBottomSheetState();
}

class _MultiSelectBottomSheetState extends State<MultiSelectBottomSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initiallySelected);
  }

  void _toggle(String id, bool? value) {
    setState(() {
      if (value == true) {
        _selected.add(id);
      } else {
        _selected.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.title, style: AppTextStyles.titleBold20),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final option = widget.options[index];
                    final selected = _selected.contains(option.id);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (value) => _toggle(option.id, value),
                      title: Text(
                        option.name,
                        style: AppTextStyles.secondaryBodySemiBold14,
                      ),
                      activeColor: AppColors.brandPrimary,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: LocaleKeys.done.tr(),
                onPressed: () => Navigator.of(context).pop(_selected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
