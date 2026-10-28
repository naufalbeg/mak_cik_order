import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/progression_service.dart';
import 'utils/audio_manager.dart';
import 'utils/constants.dart';

class MakCikOrderApp extends StatefulWidget {
  const MakCikOrderApp({super.key});

  @override
  State<MakCikOrderApp> createState() => _MakCikOrderAppState();
}

class _MakCikOrderAppState extends State<MakCikOrderApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        AudioManager.instance.suspend();
        break;
      case AppLifecycleState.resumed:
        AudioManager.instance.resumeFromBackground();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole app when settings (e.g. language) change.
    return ListenableBuilder(
      listenable: ProgressionService.instance,
      builder: (context, _) => MaterialApp(
        title: 'Mak Cik, Order!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.pandan,
            primary: AppColors.pandan,
            secondary: AppColors.turmeric,
            surface: AppColors.cream,
          ),
          scaffoldBackgroundColor: AppColors.cream,
          fontFamily: null,
          textTheme: const TextTheme().apply(
            bodyColor: AppColors.ink,
            displayColor: AppColors.ink,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? Colors.white : null,
            ),
            trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? AppColors.pandan : null,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Simple fade + slide page transition.
Route<T> gameRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
