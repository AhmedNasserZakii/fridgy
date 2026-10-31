import 'package:flutter/material.dart';

abstract class AppColors {
  // ---------------------------------------------------------------------------
  // Fridgy brand palette (from the mascot).
  // ---------------------------------------------------------------------------
  static const Color sageGreen = Color(0xFFA2B19A);
  static const Color deepSage = Color(0xFF738568);
  static const Color softCream = Color(0xFFF4E3BE);
  static const Color warmIvory = Color(0xFFFFFAF0);
  static const Color leafGreen = Color(0xFF82A52F);
  static const Color goldenYellow = Color(0xFFFFD166);
  static const Color peach = Color(0xFFF0BD96);
  static const Color warmTaupe = Color(0xFFB5A684);
  static const Color darkForest = Color(0xFF253426);

  // ---------------------------------------------------------------------------
  // Semantic tokens used by the UI — mapped onto the palette above.
  // Tints marked "derived" are lighter/darker steps of a palette color.
  // ---------------------------------------------------------------------------
  static const Color brandPrimary = Color(
    0xFF5F7055,
  ); // derived: deepSage darkened for text contrast
  static const Color brandLight = Color(0xFFE3E8DF); // derived: sageGreen tint
  static const Color accent = leafGreen;
  static const Color highlight = goldenYellow;

  static const Color textPrimary = darkForest;
  static const Color textSecondary = Color(0xFF5E6B58); // derived: forest/sage
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textFieldLabel = darkForest;
  static const Color textHint = Color(0xFF8A9483); // derived: muted sage

  static const Color surfaceDefault = warmIvory;
  static const Color surfaceAccent = Color(
    0xFFEEF1EA,
  ); // derived: sageGreen tint
  static const Color surfaceDark = darkForest;
  static const Color backgroundSecondary = Color(
    0xFFFAF1DC,
  ); // derived: softCream tint

  static const Color borderDefault = Color(
    0xFFE9E1CF,
  ); // derived: warmTaupe tint
  static const Color borderStrong = Color(
    0xFFD6CCB4,
  ); // derived: warmTaupe tint
  static const Color borderInput = Color(0xFFDDD5C1); // derived: warmTaupe tint

  static const Color error = Color(0xFFE5484D);

  /// Amber "Use soon" expiry line on food cards.
  static const Color expiryWarning = Color(0xFF9A6718);
  static const Color navInactive = Color(0xFF8A9483);
  static const Color black = Color(0xFF000000);
}
