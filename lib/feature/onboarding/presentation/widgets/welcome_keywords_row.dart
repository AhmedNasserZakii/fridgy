import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class WelcomeKeywordsRow extends StatelessWidget {
  const WelcomeKeywordsRow({super.key});

  static const List<String> _keywords = [
    'Track',
    'Cook',
    'Waste less',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          for (var i = 0; i < _keywords.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Text(
              _keywords[i],
              style: AppTextStyles.metadataMedium13,
            ),
          ],
        ],
      ),
    );
  }
}
