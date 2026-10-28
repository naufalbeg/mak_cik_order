import '../models/level_model.dart';
import '../utils/constants.dart';
import 'states_data.dart';

/// Builds six levels per state: two easy, two medium and two hard.
/// Every rule (time, goal, order size, star targets) is plain data —
/// replace the generated values with hand-tuned ones per level if needed.
List<LevelConfig> _buildLevels() {
  final levels = <LevelConfig>[];
  for (var si = 0; si < allStates.length; si++) {
    final s = allStates[si];
    final extra = si ~/ 4; // later states need a few more customers

    const t = GameTiming.defaultLevelSeconds;
    final all = s.foodIds.length;
    final specs = [
      // (difficulty, duration, goal, maxDistinct, maxQty, food count)
      (Difficulty.easy, t, 3 + extra, 1, 1, 4),
      (Difficulty.easy, t, 4 + extra, 1, 2, 4),
      (Difficulty.medium, t, 5 + extra, 2, 2, all),
      (Difficulty.medium, t, 6 + extra, 2, 3, all),
      (Difficulty.hard, t + 15, 7 + extra, 3, 3, all),
      (Difficulty.hard, t + 10, 8 + extra, 3, 4, all),
    ];

    for (var li = 0; li < specs.length; li++) {
      final (difficulty, duration, goal, maxDistinct, maxQty, foodCount) = specs[li];
      final foods = s.foodIds.take(foodCount).toList();
      final distinct = maxDistinct > foods.length ? foods.length : maxDistinct;

      // Minimum completion score = goal × correct + completion bonus.
      final base = goal * Scoring.correctOrder + Scoring.levelCompletionBonus;
      final fullStreak = (goal - 1) * Scoring.streakBonus;
      final star2 = base + (fullStreak / 2).round();
      final star3 = base + fullStreak + 15 * Scoring.timeBonusPerSecond;

      levels.add(LevelConfig(
        id: '${s.id}_${li + 1}',
        stateId: s.id,
        number: li + 1,
        difficulty: difficulty,
        durationSeconds: duration,
        customerGoal: goal,
        maxDistinctItems: distinct,
        maxQuantity: maxQty,
        star2Score: star2,
        star3Score: star3,
        foodIds: foods,
      ));
    }
  }
  return levels;
}

final List<LevelConfig> allLevels = _buildLevels();

final Map<String, LevelConfig> levelsById = {for (final l in allLevels) l.id: l};

List<LevelConfig> levelsForState(String stateId) =>
    allLevels.where((l) => l.stateId == stateId).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
