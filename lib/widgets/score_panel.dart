import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/strings.dart';

class ScorePanel extends StatelessWidget {
  final int score;
  final int coins;
  final int served;
  final int goal;
  final int streak;

  const ScorePanel({
    super.key,
    required this.score,
    required this.coins,
    required this.served,
    required this.goal,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(icon: '⭐', label: tr('score'), value: '$score'),
        const SizedBox(width: 6),
        _Chip(icon: '🪙', label: tr('coins'), value: '+$coins'),
        const SizedBox(width: 6),
        _Chip(
          icon: '🧾',
          label: tr('served_x', {'n': '$served', 'goal': '$goal'}).split(' ').first,
          value: '$served/$goal',
        ),
        const SizedBox(width: 6),
        _Chip(
          icon: streak >= 2 ? '🔥' : '➰',
          label: tr('streak'),
          value: '×$streak',
          highlight: streak >= 2,
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final bool highlight;

  const _Chip({required this.icon, required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFFFE2B8) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: highlight ? AppColors.chili : AppColors.creamDark, width: 2),
        ),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$icon $value',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
