import 'package:flutter/material.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/splash/splash_manager.dart';
import 'package:fridgy/feature/splash/view/widgets/splash_content.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.onSplashFinished,
  });

  /// Called after the splash delay (~2s). Parent wires navigation.
  final VoidCallback? onSplashFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = SplashManager(onSplashFinished: widget.onSplashFinished);
    _manager.start();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: Center(
        child: SplashContent(),
      ),
    );
  }
}
