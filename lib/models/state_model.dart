import 'package:flutter/material.dart';

import 'food_model.dart';

enum Region { peninsular, borneo }

/// A Malaysian state (or region) with its themed stall.
class MalaysianState {
  final String id;
  final String name;
  final Region region;
  final String emoji;
  final String stallName;
  final LocalizedText setting;
  final int primaryColor;
  final int secondaryColor;
  final List<String> foodIds;

  const MalaysianState({
    required this.id,
    required this.name,
    required this.region,
    required this.emoji,
    required this.stallName,
    required this.setting,
    required this.primaryColor,
    required this.secondaryColor,
    required this.foodIds,
  });

  Color get primary => Color(primaryColor);
  Color get secondary => Color(secondaryColor);
}
