import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/logic/units_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/units_state.dart';
import 'package:fridgy/feature/more/presentation/widgets/settings_select_field.dart';
import 'package:fridgy/feature/more/presentation/widgets/units_preview_row.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  Future<void> _pick({
    required BuildContext context,
    required String title,
    required List<({String value, String label})> options,
    required String current,
    required Future<void> Function(String) onSelect,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title, style: AppTextStyles.titleBold20),
              ),
              ...options.map((option) {
                return ListTile(
                  title: Text(option.label),
                  trailing: option.value == current
                      ? const Icon(Icons.check, color: AppColors.brandPrimary)
                      : null,
                  onTap: () => Navigator.pop(context, option.value),
                );
              }),
            ],
          ),
        );
      },
    );
    if (selected != null) await onSelect(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BackTitleHeader(
                title: LocaleKeys.unitsAndMeasurements.tr(),
              ),
            ),
            Expanded(
              child: BlocBuilder<UnitsCubit, UnitsState>(
                builder: (context, state) {
                  final cubit = context.read<UnitsCubit>();
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      Text(
                        LocaleKeys.unitsHeadline.tr(),
                        style: AppTextStyles.titleBold26,
                      ),
                      const SizedBox(height: 16),
                      SettingsSelectField(
                        label: LocaleKeys.region.tr(),
                        value: LocaleKeys.regionEgypt.tr(),
                        onTap: () => _pick(
                          context: context,
                          title: LocaleKeys.region.tr(),
                          current: state.region,
                          options: [
                            (
                              value: 'egypt',
                              label: LocaleKeys.regionEgypt.tr(),
                            ),
                          ],
                          onSelect: cubit.setRegion,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSelectField(
                        label: LocaleKeys.language.tr(),
                        value: state.language == 'ar'
                            ? LocaleKeys.languageArabic.tr()
                            : LocaleKeys.languageEnglish.tr(),
                        onTap: () => _pick(
                          context: context,
                          title: LocaleKeys.language.tr(),
                          current: state.language,
                          options: [
                            (
                              value: 'en',
                              label: LocaleKeys.languageEnglish.tr(),
                            ),
                            (
                              value: 'ar',
                              label: LocaleKeys.languageArabic.tr(),
                            ),
                          ],
                          onSelect: (value) async {
                            await cubit.setLanguage(value);
                            if (context.mounted) {
                              await context.setLocale(Locale(value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSelectField(
                        label: LocaleKeys.measurementSystem.tr(),
                        value: state.isMetric
                            ? LocaleKeys.measurementMetric.tr()
                            : LocaleKeys.measurementImperial.tr(),
                        onTap: () => _pick(
                          context: context,
                          title: LocaleKeys.measurementSystem.tr(),
                          current: state.measurement,
                          options: [
                            (
                              value: 'metric',
                              label: LocaleKeys.measurementMetric.tr(),
                            ),
                            (
                              value: 'imperial',
                              label: LocaleKeys.measurementImperial.tr(),
                            ),
                          ],
                          onSelect: cubit.setMeasurement,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SettingsSelectField(
                        label: LocaleKeys.savingsCurrency.tr(),
                        value: state.isEgp
                            ? LocaleKeys.currencyEgp.tr()
                            : LocaleKeys.currencyUsd.tr(),
                        onTap: () => _pick(
                          context: context,
                          title: LocaleKeys.savingsCurrency.tr(),
                          current: state.currency,
                          options: [
                            (value: 'egp', label: LocaleKeys.currencyEgp.tr()),
                            (value: 'usd', label: LocaleKeys.currencyUsd.tr()),
                          ],
                          onSelect: cubit.setCurrency,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.howItLooks.tr(),
                              style: AppTextStyles.titleBold20,
                            ),
                            UnitsPreviewRow(
                              title: LocaleKeys.previewSolidFood.tr(),
                              subtitle: state.isMetric
                                  ? LocaleKeys.previewSolidFoodMetric.tr()
                                  : LocaleKeys.previewSolidFoodImperial.tr(),
                            ),
                            UnitsPreviewRow(
                              title: LocaleKeys.previewLiquids.tr(),
                              subtitle: state.isMetric
                                  ? LocaleKeys.previewLiquidsMetric.tr()
                                  : LocaleKeys.previewLiquidsImperial.tr(),
                            ),
                            UnitsPreviewRow(
                              title: LocaleKeys.previewCountable.tr(),
                              subtitle: LocaleKeys.previewCountableValue.tr(),
                            ),
                            UnitsPreviewRow(
                              title: LocaleKeys.previewSavings.tr(),
                              subtitle: state.isEgp
                                  ? LocaleKeys.previewSavingsEgp.tr()
                                  : LocaleKeys.previewSavingsUsd.tr(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
