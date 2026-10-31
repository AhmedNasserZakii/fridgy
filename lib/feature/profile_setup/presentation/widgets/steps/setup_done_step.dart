import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/setup_illustration.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/step_intro.dart';

class SetupDoneStep extends StatelessWidget {
  const SetupDoneStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: [
        const SetupIllustration(assetPath: AppAssets.setupDone, height: 210),
        const SizedBox(height: 24),
        StepIntro(
          title: LocaleKeys.setupDoneTitle.tr(),
          subtitle: LocaleKeys.setupDoneSubtitle.tr(),
          centered: true,
        ),
      ],
    );
  }
}
