import 'package:flutter/material.dart';

import '../app.dart';
import '../services/progression_service.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/profile_widgets.dart';
import 'splash_screen.dart';
import 'tutorial_screen.dart';

/// Title screen shown on first launch, before the player registers.
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _start() {
    Navigator.of(context).pushReplacement(gameRoute(const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _start,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const GameLogo(size: 1.1),
                  const SizedBox(height: 56),
                  FadeTransition(
                    opacity: Tween(begin: 0.35, end: 1.0).animate(_pulse),
                    child: Text(
                      tr('tap_to_start'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.woodDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 220,
                    child: GameButton(
                      label: tr('start'),
                      icon: Icons.play_arrow_rounded,
                      onPressed: _start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One-time local account registration. Once saved, later launches skip
/// straight to the home screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  String _avatar = playerAvatars.first;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _name.text.trim();
    final error = validatePlayerName(name);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _saving = true);
    await ProgressionService.instance.updateSettings((s) {
      s.playerName = name;
      s.avatar = _avatar;
    });
    if (!mounted) return;
    Navigator.of(context).pushReplacement(gameRoute(const TutorialScreen(fromSplash: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: StallPanel(
                  title: tr('register_title'),
                  icon: Icons.badge_rounded,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tr('register_desc'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      AvatarCircle(avatar: _avatar, size: 96),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _name,
                        maxLength: 16,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _register(),
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        decoration: InputDecoration(
                          labelText: tr('your_name'),
                          errorText: _error,
                          filled: true,
                          fillColor: fade(Colors.white, 0.7),
                          prefixIcon: const Icon(Icons.person_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(tr('choose_avatar'), style: const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 10),
                      AvatarPicker(selected: _avatar, onChanged: (a) => setState(() => _avatar = a)),
                      const SizedBox(height: 24),
                      GameButton(
                        label: tr('register'),
                        icon: Icons.check_rounded,
                        onPressed: _saving ? null : _register,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
