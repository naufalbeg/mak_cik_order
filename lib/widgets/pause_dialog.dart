import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/strings.dart';
import 'common.dart';

/// Full-screen pause overlay. Gameplay and timer are frozen underneath.
class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: fade(Colors.black, 0.55),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.wood, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('☕', style: TextStyle(fontSize: 48)),
                Text(
                  tr('paused'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.woodDark,
                  ),
                ),
                const SizedBox(height: 18),
                GameButton(label: tr('resume'), icon: Icons.play_arrow_rounded, onPressed: onResume),
                const SizedBox(height: 12),
                GameButton(
                  label: tr('restart'),
                  icon: Icons.replay_rounded,
                  color: AppColors.turmeric,
                  shadow: const Color(0xFFB98A00),
                  textColor: AppColors.ink,
                  onPressed: onRestart,
                ),
                const SizedBox(height: 12),
                GameButton(
                  label: tr('main_menu'),
                  icon: Icons.home_rounded,
                  color: AppColors.wood,
                  shadow: AppColors.woodDark,
                  onPressed: onMainMenu,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
