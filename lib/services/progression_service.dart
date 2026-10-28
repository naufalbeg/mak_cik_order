import 'package:flutter/foundation.dart';

import '../data/levels_data.dart';
import '../data/shop_data.dart';
import '../data/states_data.dart';
import '../models/level_model.dart';
import '../models/player_progress.dart';
import '../models/shop_item.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

enum PurchaseResult { success, alreadyOwned, insufficientCoins }

class LevelRecordOutcome {
  final bool isNewBest;
  final String? unlockedStateId;
  final List<String> newFoods;

  const LevelRecordOutcome({
    required this.isNewBest,
    required this.unlockedStateId,
    required this.newFoods,
  });
}

/// Single source of truth for saved progress and settings.
/// Widgets listen to it to rebuild when coins, unlocks or language change.
class ProgressionService extends ChangeNotifier {
  ProgressionService._();
  static final ProgressionService instance = ProgressionService._();

  final StorageService _storage = StorageService();

  PlayerProgress progress = PlayerProgress();
  GameSettings settings = GameSettings();
  bool loaded = false;

  String get lang => settings.language;
  int get coins => progress.coins;

  Future<void> load() async {
    progress = await _storage.loadProgress();
    settings = await _storage.loadSettings();
    _ensureDefaults();
    loaded = true;
    notifyListeners();
  }

  void _ensureDefaults() {
    for (final e in defaultEquipped.entries) {
      progress.ownedItems.add(e.value);
      final current = progress.equipped[e.key.name];
      if (current == null ||
          !progress.ownedItems.contains(current) ||
          shopItemsById[current]?.category != e.key) {
        progress.equipped[e.key.name] = e.value;
      }
    }
  }

  Future<void> _saveProgress() => _storage.saveProgress(progress);
  Future<void> _saveSettings() => _storage.saveSettings(settings);

  // ───────────── Levels & states ─────────────

  bool isLevelCompleted(String levelId) =>
      progress.completedLevels.contains(levelId);

  bool isStateCompleted(String stateId) =>
      levelsForState(stateId).every((l) => isLevelCompleted(l.id));

  bool isStateUnlocked(String stateId) {
    final idx = stateIndexOf(stateId);
    if (idx <= 0) return idx == 0;
    return isStateCompleted(allStates[idx - 1].id);
  }

  bool isLevelUnlocked(LevelConfig level) {
    if (!isStateUnlocked(level.stateId)) return false;
    if (level.number == 1) return true;
    return isLevelCompleted('${level.stateId}_${level.number - 1}');
  }

  int starsFor(String levelId) => progress.stars[levelId] ?? 0;
  int bestScoreFor(String levelId) => progress.bestScores[levelId] ?? 0;

  int starsForState(String stateId) =>
      levelsForState(stateId).fold(0, (sum, l) => sum + starsFor(l.id));

  int get totalStars => progress.stars.values.fold(0, (a, b) => a + b);
  int get maxStars => allLevels.length * 3;

  /// First unlocked level not yet completed — used by "Continue".
  LevelConfig get continueLevel {
    for (final s in allStates) {
      for (final l in levelsForState(s.id)) {
        if (isLevelUnlocked(l) && !isLevelCompleted(l.id)) return l;
      }
    }
    return allLevels.last;
  }

  bool get hasAnyProgress =>
      progress.completedLevels.isNotEmpty || progress.totalServed > 0;

  /// Saves a finished level. Called exactly once per run.
  Future<LevelRecordOutcome> recordLevelResult({
    required LevelConfig level,
    required int score,
    required int stars,
    required bool completed,
    required int coinsEarned,
    required int ordersServed,
    required Set<String> servedFoodIds,
  }) async {
    final wasStateUnlockedBefore = <String, bool>{
      for (final s in allStates) s.id: isStateUnlocked(s.id),
    };

    final previousBest = bestScoreFor(level.id);
    final isNewBest = completed && score > previousBest;
    if (completed) {
      progress.completedLevels.add(level.id);
      if (isNewBest) progress.bestScores[level.id] = score;
      if (stars > starsFor(level.id)) progress.stars[level.id] = stars;
    }
    progress.coins += coinsEarned < 0 ? 0 : coinsEarned;
    progress.totalServed += ordersServed;
    if (!completed) _loseLife();

    final newFoods = <String>[];
    for (final f in servedFoodIds) {
      if (progress.discoveredFoods.add(f)) newFoods.add(f);
    }

    String? unlocked;
    for (final s in allStates) {
      if (!wasStateUnlockedBefore[s.id]! && isStateUnlocked(s.id)) {
        unlocked = s.id;
        break;
      }
    }

    notifyListeners();
    await _saveProgress();
    return LevelRecordOutcome(
      isNewBest: isNewBest,
      unlockedStateId: unlocked,
      newFoods: newFoods,
    );
  }

  bool isFoodDiscovered(String foodId) =>
      progress.discoveredFoods.contains(foodId);

  // ───────────── Lives ─────────────

  int get lives {
    _refillLivesIfDue();
    return progress.lives;
  }

  bool get hasLives => lives > 0;

  /// Time until lives refill to full, or null while lives are full.
  Duration? get livesRefillIn {
    _refillLivesIfDue();
    final at = progress.livesRefillAt;
    if (at == null) return null;
    final left = at - DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: left < 0 ? 0 : left);
  }

  void _refillLivesIfDue() {
    final at = progress.livesRefillAt;
    if (progress.lives >= Lives.max) {
      progress.livesRefillAt = null;
      return;
    }
    if (at != null && DateTime.now().millisecondsSinceEpoch < at) return;
    if (at == null) {
      // Missing timer (e.g. old save): start one rather than refill instantly.
      progress.livesRefillAt =
          DateTime.now().add(Lives.refill).millisecondsSinceEpoch;
      return;
    }
    progress.lives = Lives.max;
    progress.livesRefillAt = null;
    _saveProgress();
  }

  void _loseLife() {
    _refillLivesIfDue();
    if (progress.lives <= 0) return;
    progress.lives--;
    progress.livesRefillAt ??=
        DateTime.now().add(Lives.refill).millisecondsSinceEpoch;
  }

  /// Costs one life outside a finished level (restarting or quitting a run).
  Future<void> spendLife() async {
    _loseLife();
    notifyListeners();
    await _saveProgress();
  }

  /// Re-evaluates the refill timer and tells listeners (used by countdowns).
  void tickLives() {
    final before = progress.lives;
    _refillLivesIfDue();
    if (progress.lives != before) notifyListeners();
  }

  // ───────────── Shop ─────────────

  bool owns(String itemId) => progress.ownedItems.contains(itemId);

  String equippedId(ShopCategory c) =>
      progress.equipped[c.name] ?? defaultEquipped[c]!;

  ShopItem equippedItem(ShopCategory c) =>
      shopItemsById[equippedId(c)] ?? shopItemsById[defaultEquipped[c]!]!;

  bool isEquipped(ShopItem item) => equippedId(item.category) == item.id;

  Future<PurchaseResult> buy(ShopItem item) async {
    if (owns(item.id)) return PurchaseResult.alreadyOwned;
    if (progress.coins < item.price) return PurchaseResult.insufficientCoins;
    progress.coins -= item.price;
    progress.ownedItems.add(item.id);
    progress.equipped[item.category.name] = item.id;
    notifyListeners();
    await _saveProgress();
    return PurchaseResult.success;
  }

  Future<void> equip(ShopItem item) async {
    if (!owns(item.id)) return;
    progress.equipped[item.category.name] = item.id;
    notifyListeners();
    await _saveProgress();
  }

  // ───────────── Settings ─────────────

  Future<void> updateSettings(void Function(GameSettings s) change) async {
    change(settings);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> resetProgress() async {
    await _storage.clearProgress();
    progress = PlayerProgress();
    _ensureDefaults();
    notifyListeners();
    await _saveProgress();
  }
}
