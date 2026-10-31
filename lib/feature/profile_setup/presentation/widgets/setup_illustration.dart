import 'package:flutter/material.dart';

class SetupIllustration extends StatelessWidget {
  const SetupIllustration({
    super.key,
    required this.assetPath,
    this.height = 160,
  });

  final String assetPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Image.asset(
        assetPath,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
