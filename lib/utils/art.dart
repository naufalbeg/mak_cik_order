import 'package:flutter/material.dart';

/// Paths to the illustrated art in assets/images/.
class Art {
  static const String home = 'assets/images/backgrounds/bg_home.jpg';

  static String stateBackground(String stateId) => 'assets/images/backgrounds/bg_$stateId.jpg';

  /// mood: 'neutral', 'happy' or 'worried'
  static String makCik(String mood) => 'assets/images/characters/makcik_$mood.png';

  /// mood: 'neutral', 'happy' or 'angry'
  static String customer(String sprite, String mood) => 'assets/images/characters/${sprite}_$mood.png';

  /// Customer characters drawn in assets/images/characters/.
  static const List<String> customerSprites = [
    'pakcik',
    'makcik_glasses',
    'uncle',
    'auntie',
    'student',
    'boy',
    'office',
    'girl',
    'rider',
    'teen',
  ];
}

/// Image.asset that shows [fallback] instead of crashing if the file is missing.
class ArtImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final Widget? fallback;

  const ArtImage(
    this.path, {
    super.key,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stack) => fallback ?? SizedBox(width: width, height: height),
    );
  }
}
