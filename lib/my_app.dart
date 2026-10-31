import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/core/theme/styles/app_theme.dart';
import 'package:fridgy/core/theme/theme_controller.dart';
import 'package:fridgy/core/utils/app_route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Fridgy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeController.themeMode,
          navigatorKey: AppRoute.navigatorKey,
          initialRoute: AppRoute.splash,
          onGenerateRoute: AppRoute.onGenerateRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
