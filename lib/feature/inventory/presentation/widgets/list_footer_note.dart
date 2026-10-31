import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

/// Static helper note shown at the bottom of a list (e.g. Expiring Soon, D14).
class ListFooterNote extends StatelessWidget {
  const ListFooterNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.captionRegular12);
  }
}
