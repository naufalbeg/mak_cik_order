import 'package:flutter/material.dart';

/// Palette from the UI/UX guidelines: cream, pandan green, wood brown and
/// food-inspired accents.
class AppColors {
  static const cream = Color(0xFFFFF6E5);
  static const creamDark = Color(0xFFF3E2C2);
  static const pandan = Color(0xFF4E9F3D);
  static const pandanDark = Color(0xFF2F6B2A);
  static const wood = Color(0xFF8B5A2B);
  static const woodDark = Color(0xFF5C3A1B);
  static const chili = Color(0xFFD9483B);
  static const turmeric = Color(0xFFF2B705);
  static const ink = Color(0xFF3B2A1A);
  static const muted = Color(0xFF8A7560);
}

/// Scoring values from section 4.3 of the draft. These are starting
/// assumptions — tune them after play-testing.
class Scoring {
  static const int correctOrder = 100;
  static const int incorrectOrder = -20;
  static const int streakBonus = 25;
  static const int timeBonusPerSecond = 2;
  static const int levelCompletionBonus = 100;

  static const int coinsPerCorrect = 10;
  static const int coinsPerStar = 15;
}

class GameTiming {
  static const int feedbackMs = 1100;
  static const int tickMs = 100;
  static const int defaultLevelSeconds = 60;
}

/// Losing a level costs one life; lives refill to full an hour after the
/// first one is lost.
class Lives {
  static const int max = 5;
  static const Duration refill = Duration(hours: 1);
}

/// Opacity helper that avoids deprecated APIs across Flutter versions.
Color fade(Color c, double opacity) =>
    c.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
