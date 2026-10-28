import 'package:flutter/material.dart';

import '../app.dart';
import '../data/foods_data.dart';
import '../data/levels_data.dart';
import '../data/states_data.dart';
import '../models/level_model.dart';
import '../services/game_service.dart';
import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/food_image.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final LevelResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _stars = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    final r = widget.result;
    AudioManager.instance.play(r.completed ? Sfx.levelWin : Sfx.levelLose);
    if (r.completed) AudioManager.instance.vibrate();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _stars.forward();
    });
  }

  @override
  void dispose() {
    _stars.dispose();
    super.dispose();
  }

  LevelConfig? get _nextLevel {
    final current = widget.result.level;
    final sameState = levelsForState(current.stateId);
    final idx = sameState.indexWhere((l) => l.id == current.id);
    if (idx >= 0 && idx < sameState.length - 1) return sameState[idx + 1];
    final sIdx = stateIndexOf(current.stateId);
    if (sIdx >= 0 && sIdx < allStates.length - 1) {
      final next = levelsForState(allStates[sIdx + 1].id);
      if (next.isNotEmpty) return next.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final state = statesById[r.level.stateId]!;
    final next = _nextLevel;
    final canNext = next != null && ProgressionService.instance.isLevelUnlocked(next);

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: PatternBackground(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              children: [
                Text(
                  r.completed ? tr('level_complete') : tr('level_failed'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: r.completed ? AppColors.pandanDark : AppColors.chili,
                  ),
                ),
                Text(
                  '${state.name} • ${tr('level_n', {'n': '${r.level.number}'})}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: AppColors.muted, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                // Animated stars
                AnimatedBuilder(
                  animation: _stars,
                  builder: (context, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(3, (i) {
                      final start = i / 3;
                      final t = ((_stars.value - start) * 3).clamp(0.0, 1.0).toDouble();
                      final earned = i < r.stars;
                      final scale = earned ? Curves.elasticOut.transform(t) : 1.0;
                      final size = i == 1 ? 76.0 : 60.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Transform.scale(
                          scale: earned ? scale : 1.0,
                          child: Icon(
                            earned && t > 0 ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: size,
                            color: earned && t > 0 ? AppColors.turmeric : fade(AppColors.wood, 0.35),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (r.isNewBest)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.chili,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '🏆 ${tr('new_best')}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                if (!r.completed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      tr('level_failed_body', {'n': '${r.level.customerGoal}'}),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.wood, width: 3),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${r.score}',
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: AppColors.woodDark),
                      ),
                      Text(tr('score'), style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
                      const Divider(height: 24),
                      _StatRow(tr('customers_served'), '${r.served}'),
                      _StatRow(tr('correct_orders'), '${r.correctOrders}/${r.level.customerGoal}'),
                      _StatRow(tr('accuracy'), '${(r.accuracy * 100).round()}%'),
                      _StatRow(tr('best_streak'), '×${r.bestStreak}'),
                      if (r.timeBonus > 0) _StatRow(tr('time_bonus'), '+${r.timeBonus}'),
                      if (r.completionBonus > 0) _StatRow(tr('completion_bonus'), '+${r.completionBonus}'),
                      const Divider(height: 20),
                      _StatRow(tr('coins_earned'), '🪙 +${r.coinsEarned}', bold: true),
                      if (!r.completed) _StatRow(tr('life_lost'), '💔 -1', bold: true),
                    ],
                  ),
                ),
                if (r.unlockedStateId != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.pandan,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '🗺️ ${tr('state_unlocked', {'state': statesById[r.unlockedStateId]?.name ?? ''})}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ],
                if (r.newFoods.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    '📖 ${tr('new_foods')}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.woodDark),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final id in r.newFoods)
                        if (foodById(id) != null)
                          Chip(
                            backgroundColor: Colors.white,
                            avatar: FoodImage(food: foodById(id)!, size: 28),
                            label: Text(foodById(id)!.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          ),
                    ],
                  ),
                ],
                const SizedBox(height: 22),
                if (r.completed && canNext) ...[
                  GameButton(
                    label: tr('next_level'),
                    icon: Icons.arrow_forward_rounded,
                    color: AppColors.chili,
                    shadow: const Color(0xFF9E2B21),
                    onPressed: () {
                      if (!ensureLives(context)) return;
                      Navigator.of(context).pushReplacement(gameRoute(GameScreen(level: next)));
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                GameButton(
                  label: tr('replay'),
                  icon: Icons.replay_rounded,
                  onPressed: () {
                    if (!ensureLives(context)) return;
                    Navigator.of(context).pushReplacement(gameRoute(GameScreen(level: r.level)));
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GameButton(
                        label: tr('to_map'),
                        icon: Icons.map_rounded,
                        fontSize: 15,
                        color: AppColors.wood,
                        shadow: AppColors.woodDark,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GameButton(
                        label: tr('main_menu'),
                        icon: Icons.home_rounded,
                        fontSize: 15,
                        color: AppColors.turmeric,
                        shadow: const Color(0xFFB98A00),
                        textColor: AppColors.ink,
                        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _StatRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, fontWeight: bold ? FontWeight.w900 : FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: bold ? FontWeight.w900 : FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
