import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';

class SearchResultsCount extends StatelessWidget {
  const SearchResultsCount({
    required this.count,
    required this.firstName,
    super.key,
  });

  final int count;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.searchMatchesCount.tr(args: ['$count', firstName]),
      style: AppTextStyles.secondaryBodyRegular14Text,
    );
  }
}
