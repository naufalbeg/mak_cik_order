/// Each state has two levels of each difficulty. The name doubles as the
/// translation key.
enum Difficulty { easy, medium, hard }

/// Per-level configuration. All gameplay rules are data, so new states
/// reuse the same game logic.
class LevelConfig {
  final String id;
  final String stateId;
  final int number;
  final Difficulty difficulty;
  final int durationSeconds;

  /// Correct orders needed to complete the level.
  final int customerGoal;

  /// Maximum different foods in one order.
  final int maxDistinctItems;

  /// Maximum quantity of a single food in one order.
  final int maxQuantity;

  final int star2Score;
  final int star3Score;
  final List<String> foodIds;
  final bool hintEnabled;
  final bool timeBonusEnabled;

  const LevelConfig({
    required this.id,
    required this.stateId,
    required this.number,
    required this.difficulty,
    required this.durationSeconds,
    required this.customerGoal,
    required this.maxDistinctItems,
    required this.maxQuantity,
    required this.star2Score,
    required this.star3Score,
    required this.foodIds,
    this.hintEnabled = true,
    this.timeBonusEnabled = true,
  });
}
