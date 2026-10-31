import 'package:flutter/material.dart';

class FridgeAiComposerIconButton extends StatelessWidget {
  const FridgeAiComposerIconButton({
    required this.background,
    required this.onTap,
    required this.child,
    super.key,
  });

  final Color background;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(width: 44, height: 44, child: Center(child: child)),
      ),
    );
  }
}
