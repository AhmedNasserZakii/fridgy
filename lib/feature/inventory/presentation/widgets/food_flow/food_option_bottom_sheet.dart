import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

Future<T?> showFoodOptionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<FoodOptionSheetItem<T>> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surfaceDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: AppTextStyles.titleBold20),
              const SizedBox(height: 12),
              ...options.map((option) {
                final isSelected = selected == option.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option.label,
                    style: isSelected
                        ? AppTextStyles.bodySemiBold16Brand
                        : AppTextStyles.bodyRegular16,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.brandPrimary)
                      : null,
                  onTap: () => Navigator.of(context).pop(option.value),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

class FoodOptionSheetItem<T> {
  const FoodOptionSheetItem({required this.label, required this.value});

  final String label;
  final T value;
}
