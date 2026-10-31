import 'package:flutter/material.dart';
import 'package:fridgy/feature/splash/view/widgets/splash_brand_name.dart';
import 'package:fridgy/feature/splash/view/widgets/splash_logo.dart';
import 'package:fridgy/feature/splash/view/widgets/splash_tagline.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SplashLogo(),
        SizedBox(height: 24),
        SplashBrandName(),
        SplashTagline(),
      ],
    );
  }
}
