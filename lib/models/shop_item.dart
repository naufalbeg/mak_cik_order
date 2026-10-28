import 'package:flutter/material.dart';

import 'food_model.dart';

enum ShopCategory { table, decoration, clothing, signboard, theme }

/// Cosmetic-only items. They never affect gameplay balance.
class ShopItem {
  final String id;
  final ShopCategory category;
  final LocalizedText name;
  final int price;
  final String emoji;
  final int colorValue;
  final int colorValue2;

  const ShopItem({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.emoji,
    required this.colorValue,
    required this.colorValue2,
  });

  Color get color => Color(colorValue);
  Color get color2 => Color(colorValue2);
}
