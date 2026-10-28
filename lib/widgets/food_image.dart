import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../utils/constants.dart';

/// Shows the food's illustration (assets/images/foods/<id>.png).
/// Locked foods appear as a grey silhouette with a padlock.
/// If the image file is missing, a coloured emoji badge is drawn instead,
/// so a missing asset never crashes the game.
class FoodImage extends StatelessWidget {
  final FoodItem food;
  final double size;
  final bool locked;

  const FoodImage({super.key, required this.food, this.size = 56, this.locked = false});

  /// Turns the picture into a flat grey silhouette.
  static const ColorFilter _silhouette = ColorFilter.matrix(<double>[
    0, 0, 0, 0, 175, //
    0, 0, 0, 0, 165, //
    0, 0, 0, 0, 155, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      food.imageAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      // Decode at display size to keep memory low on older phones.
      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round().clamp(32, 512).toInt(),
      errorBuilder: (context, error, stack) => _Placeholder(food: food, size: size, locked: locked),
    );

    if (!locked) return SizedBox(width: size, height: size, child: image);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ColorFiltered(colorFilter: _silhouette, child: image),
          Container(
            padding: EdgeInsets.all(size * 0.08),
            decoration: BoxDecoration(
              color: fade(Colors.white, 0.85),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_rounded, size: size * 0.3, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final FoodItem food;
  final double size;
  final bool locked;

  const _Placeholder({required this.food, required this.size, required this.locked});

  @override
  Widget build(BuildContext context) {
    final c = locked ? Colors.grey.shade400 : food.color;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [fade(Colors.white, 0.95), fade(c, 0.55)],
          stops: const [0.35, 1.0],
        ),
        border: Border.all(color: fade(c, 0.9), width: size * 0.05),
      ),
      child: locked
          ? Icon(Icons.lock_rounded, size: size * 0.42, color: Colors.grey.shade600)
          : Text(food.emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
