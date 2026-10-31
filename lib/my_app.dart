import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_theme.dart';
import 'package:fridgy/feature/onboarding/presentation/pages/onboarding_steps_screen.dart';
import 'package:fridgy/feature/onboarding/presentation/pages/welcome_screen.dart';
import 'package:fridgy/feature/splash/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridgy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

enum _AppPhase { splash, welcome, steps, done }

class _AppEntryState extends State<AppEntry> {
  _AppPhase _phase = _AppPhase.splash;

  void _goToWelcome() {
    setState(() => _phase = _AppPhase.welcome);
  }

  void _goToSteps() {
    setState(() => _phase = _AppPhase.steps);
  }

  void _finishOnboarding() {
    setState(() => _phase = _AppPhase.done);
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _AppPhase.splash:
        return SplashScreen(onSplashFinished: _goToWelcome);
      case _AppPhase.welcome:
        return WelcomeScreen(
          onGetStarted: _goToSteps,
          onSignIn: _finishOnboarding,
        );
      case _AppPhase.steps:
        return OnboardingStepsScreen(
          onFinished: _finishOnboarding,
          onSkip: _finishOnboarding,
        );
      case _AppPhase.done:
        return const Scaffold(
          body: Center(
            child: Text('Home coming soon'),
          ),
        );
    }
  }
}
