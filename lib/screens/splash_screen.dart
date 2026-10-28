import 'package:flutter/material.dart';

import '../app.dart';
import '../services/progression_service.dart';
import '../utils/art.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import 'home_screen.dart';
import 'start_screen.dart';
import 'tutorial_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final minDelay = Future<void>.delayed(const Duration(milliseconds: 1600));
    try {
      await ProgressionService.instance.load();
      await AudioManager.instance.init();
    } catch (e) {
      debugPrint('Startup error: $e');
    }
    await minDelay;
    if (!mounted) return;
    AudioManager.instance.startMusic();
    final settings = ProgressionService.instance.settings;
    final Widget next;
    if (!settings.isRegistered) {
      next = const StartScreen();
    } else if (!settings.tutorialSeen) {
      next = const TutorialScreen(fromSplash: true);
    } else {
      next = const HomeScreen();
    }
    Navigator.of(context).pushReplacement(gameRoute(next));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GameLogo(size: 1.0),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(color: AppColors.pandan, strokeWidth: 4),
                ),
                const SizedBox(height: 12),
                Text(tr('loading'), style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The game title lockup.
class GameLogo extends StatelessWidget {
  final double size;

  /// Show Mak Cik's portrait above the title.
  final bool showMascot;
  const GameLogo({super.key, this.size = 1.0, this.showMascot = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMascot) ...[
          Container(
            width: 130 * size,
            height: 130 * size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFFFFF6D8), Color(0xFFFFC56B)]),
              border: Border.all(color: AppColors.woodDark, width: 5 * size),
              boxShadow: [BoxShadow(color: fade(AppColors.wood, 0.35), offset: const Offset(0, 6))],
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.only(top: 10 * size),
                child: ArtImage(
                  Art.makCik('happy'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  fallback: Center(child: Text('🧕🏽', style: TextStyle(fontSize: 64 * size))),
                ),
              ),
            ),
          ),
          SizedBox(height: 14 * size),
        ],
        Stack(
          children: [
            Text(
              'Mak Cik, Order!',
              style: TextStyle(
                fontSize: 38 * size,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 7 * size
                  ..color = AppColors.woodDark,
              ),
            ),
            Text(
              'Mak Cik, Order!',
              style: TextStyle(
                fontSize: 38 * size,
                fontWeight: FontWeight.w900,
                color: AppColors.turmeric,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 6 * size),
          padding: EdgeInsets.symmetric(horizontal: 14 * size, vertical: 4 * size),
          decoration: BoxDecoration(
            color: AppColors.pandan,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Jelajah Rasa Malaysia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16 * size,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
