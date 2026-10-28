import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Horizontal countdown bar that turns red when time is low.
class GameTimer extends StatelessWidget {
  final double fraction;
  final double secondsLeft;

  const GameTimer({super.key, required this.fraction, required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final low = secondsLeft <= 10;
    final color = low
        ? AppColors.chili
        : fraction < 0.5
            ? AppColors.turmeric
            : AppColors.pandan;
    return Row(
      children: [
        Icon(Icons.timer_rounded, color: low ? AppColors.chili : AppColors.woodDark, size: 22),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              color: fade(AppColors.wood, 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.wood, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  heightFactor: 1,
                  child: Container(color: color),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${secondsLeft.ceil()}s',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: low ? AppColors.chili : AppColors.woodDark,
            ),
          ),
        ),
      ],
    );
  }
}
