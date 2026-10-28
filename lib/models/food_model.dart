import 'package:flutter/material.dart';

/// A string available in English and Bahasa Melayu.
class LocalizedText {
  final String en;
  final String ms;

  const LocalizedText(this.en, this.ms);

  String of(String lang) => lang == 'en' ? en : ms;
}

class FoodItem {
  final String id;
  final String name;
  final String stateId;

  /// Placeholder glyph shown when no illustration asset is available.
  final String emoji;
  final int colorValue;

  /// Optional custom illustration path. When null, the game looks for
  /// 'assets/images/foods/<id>.png' automatically (see [imageAsset]).
  final String? imagePath;

  final LocalizedText description;
  final List<String> ingredients;
  final LocalizedText culturalFact;

  const FoodItem({
    required this.id,
    required this.name,
    required this.stateId,
    required this.emoji,
    required this.colorValue,
    required this.description,
    required this.ingredients,
    required this.culturalFact,
    this.imagePath,
  });

  Color get color => Color(colorValue);

  /// Illustration to show for this food. New foods only need a PNG named
  /// after their id in assets/images/foods/ — no code change required.
  String get imageAsset => imagePath ?? 'assets/images/foods/$id.png';
}
