import 'package:flutter/material.dart';

abstract class AppColors {
  // Figma Home tokens (file gjTj3VJepWpXHMHG9pCuvh) — visuals follow Figma.
  static const Color brandPrimary = Color(0xFF087CB9);
  static const Color brandLight = Color(0xFFDDF4FC);
  static const Color textPrimary = Color(0xFF152F40);
  static const Color textSecondary = Color(0xFF647986);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textFieldLabel = Color(0xFF203D2D);
  static const Color textHint = Color(0xFF6C7569);
  static const Color surfaceDefault = Color(0xFFFFFFFF);
  static const Color surfaceAccent = Color(0xFFEAF8FD);
  static const Color surfaceDark = Color(0xFF0F1C24);
  static const Color backgroundSecondary = Color(0xFFF7FAFC);
  static const Color borderDefault = Color(0xFFE4EDF2);
  static const Color borderStrong = Color(0xFFCCDDE7);
  static const Color borderInput = Color(0xFFDDE3D5);
  // Provisional — Figma has no error token; confirm at Checkpoint A.
  static const Color error = Color(0xFFE5484D);

  /// Amber "Use soon" expiry line from Figma food cards.
  static const Color expiryWarning = Color(0xFF9A6718);
  static const Color navInactive = Color(0xFF647986);
  static const Color black = Color(0xFF000000);
}
