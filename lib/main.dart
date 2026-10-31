import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/constants/app_localization.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppLocalizations.englishLocale,
        AppLocalizations.arabicLocale,
      ],
      path: AppLocalizations.translationsPath,
      fallbackLocale: AppLocalizations.englishLocale,
      startLocale: AppLocalizations.englishLocale,
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}
