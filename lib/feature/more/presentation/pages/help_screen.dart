import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/more/presentation/widgets/faq_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _copySupportEmail(BuildContext context) async {
    final email = LocaleKeys.supportEmail.tr();
    await Clipboard.setData(ClipboardData(text: email));
    if (context.mounted) {
      AppSnackBar.show(context, email);
    }
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
              child: BackTitleHeader(title: LocaleKeys.helpAndSupport.tr()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    LocaleKeys.helpHeadline.tr(),
                    style: AppTextStyles.titleBold26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.frequentlyAsked.tr(),
                    style: AppTextStyles.titleBold20,
                  ),
                  const SizedBox(height: 16),
                  FaqCard(
                    title: LocaleKeys.faqDatesTitle.tr(),
                    body: LocaleKeys.faqDatesBody.tr(),
                  ),
                  const SizedBox(height: 16),
                  FaqCard(
                    title: LocaleKeys.faqScannerTitle.tr(),
                    body: LocaleKeys.faqScannerBody.tr(),
                  ),
                  const SizedBox(height: 16),
                  FaqCard(
                    title: LocaleKeys.faqInventoryTitle.tr(),
                    body: LocaleKeys.faqInventoryBody.tr(),
                  ),
                  const SizedBox(height: 16),
                  FaqCard(
                    title: LocaleKeys.faqShareTitle.tr(),
                    body: LocaleKeys.faqShareBody.tr(),
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: AppColors.surfaceAccent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => _copySupportEmail(context),
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.icMail,
                              width: 22,
                              height: 22,
                              colorFilter: const ColorFilter.mode(
                                AppColors.brandPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.contactSupport.tr(),
                              style: AppTextStyles.bodySemiBold16Brand,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.supportEmail.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.secondaryBodyRegular14,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.helpVersionLine.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.captionRegular12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
