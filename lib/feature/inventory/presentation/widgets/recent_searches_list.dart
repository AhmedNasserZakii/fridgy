import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/recent_search_row.dart';

class RecentSearchesList extends StatelessWidget {
  const RecentSearchesList({
    required this.searches,
    required this.onTap,
    super.key,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.recentSearches.tr(), style: AppTextStyles.titleBold20),
        const SizedBox(height: 8),
        for (final query in searches)
          RecentSearchRow(query: query, onTap: () => onTap(query)),
      ],
    );
  }
}
