import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/customer_model.dart';
import '../models/level_model.dart';
import '../utils/constants.dart';
import 'order_service.dart';
import 'progression_service.dart';

enum GamePhase { ready, playing, paused, feedback, ended }

enum FeedbackKind { correct, incorrect, empty }

class OrderFeedback {
  final FeedbackKind kind;
  final int points;
  final int streakBonus;
  final int coins;

  const OrderFeedback({
    required this.kind,
    this.points = 0,
    this.streakBonus = 0,
    this.coins = 0,
  });
}

class LevelResult {
  final LevelConfig level;
  final bool completed;
  final int score;
  final int baseScore;
  final int timeBonus;
  final int completionBonus;
  final int correctOrders;
  final int wrongOrders;
  final int bestStreak;
  final int coinsEarned;
  final int stars;
  final bool isNewBest;
  final String? unlockedStateId;
  final List<String> newFoods;

  const LevelResult({
    required this.level,
    required this.completed,
    required this.score,
    required this.baseScore,
    required this.timeBonus,
    required this.completionBonus,
    required this.correctOrders,
    required this.wrongOrders,
    required this.bestStreak,
    required this.coinsEarned,
    required this.stars,
    required this.isNewBest,
    required this.unlockedStateId,
    required this.newFoods,
  });

  int get served => correctOrders + wrongOrders;
  double get accuracy => served == 0 ? 0 : correctOrders / served;
}

/// One run of one level. Owns the timer, the current customer,
/// the player's tray selection and scoring.
class GameSession extends ChangeNotifier {
  final LevelConfig level;
  final OrderService _orders;
  final ProgressionService _progression;

  GameSession(this.level, {Random? rng, ProgressionService? progression})
      : _orders = OrderService(rng),
        _progression = progression ?? ProgressionService.instance,
        _remainingMs = level.durationSeconds * 1000.0;

  GamePhase phase = GamePhase.ready;
  GamePhase _phaseBeforePause = GamePhase.playing;
  Customer? customer;
  final Map<String, int> selection = {};

  int score = 0;
  int correctOrders = 0;
  int wrongOrders = 0;
  int streak = 0;
  int bestStreak = 0;
  int coinsEarned = 0;
  bool hintVisible = false;
  OrderFeedback? feedback;
  final Set<String> servedFoods = {};

  /// Bumped each new customer so widgets can animate arrivals.
  int customerSerial = 0;

  double _remainingMs;
  Timer? _ticker;
  Timer? _feedbackTimer;
  DateTime? _lastTick;
  bool _pendingAfterFeedback = false;
  bool _disposed = false;

  Future<LevelResult>? finalResult;

  static const int maxQuantityPerFood = 9;

  /// Wrong orders allowed before the level is lost.
  static const int maxWrongOrders = 3;

  bool get outOfMistakes => wrongOrders >= maxWrongOrders;

  // ───────────── Getters ─────────────

  double get remainingSeconds => _remainingMs / 1000.0;
  double get timeFraction =>
      (_remainingMs / (level.durationSeconds * 1000.0)).clamp(0.0, 1.0).toDouble();
  bool get acceptsInput => phase == GamePhase.playing;
  bool get isPaused => phase == GamePhase.paused;
  bool get isEnded => phase == GamePhase.ended;
  int get selectedCount => selection.values.fold(0, (a, b) => a + b);
  int quantityOf(String foodId) => selection[foodId] ?? 0;

  // ───────────── Lifecycle ─────────────

  void start() {
    if (phase != GamePhase.ready) return;
    _remainingMs = level.durationSeconds * 1000.0;
    _nextCustomer();
    phase = GamePhase.playing;
    _lastTick = DateTime.now();
    _ticker = Timer.periodic(
      const Duration(milliseconds: GameTiming.tickMs),
      (_) => _tick(),
    );
    _notify();
  }

  void _tick() {
    final now = DateTime.now();
    final last = _lastTick ?? now;
    _lastTick = now;

    // Timer runs only during active gameplay (incl. the brief feedback).
    if (phase != GamePhase.playing && phase != GamePhase.feedback) return;

    _remainingMs -= now.difference(last).inMilliseconds;
    if (_remainingMs <= 0) {
      _remainingMs = 0;
      if (phase == GamePhase.playing) {
        _endLevel();
        return;
      }
      // If feedback is showing, the level ends right after it.
    }
    _notify();
  }

  void pause() {
    if (phase != GamePhase.playing && phase != GamePhase.feedback) return;
    _phaseBeforePause = phase;
    phase = GamePhase.paused;
    _notify();
  }

  void resume() {
    if (phase != GamePhase.paused) return;
    phase = _phaseBeforePause;
    _lastTick = DateTime.now();
    _notify();
    if (_pendingAfterFeedback) {
      _pendingAfterFeedback = false;
      _afterFeedback();
    }
  }

  /// Ends the run immediately (used when quitting to the menu).
  void abandon() {
    _ticker?.cancel();
    _feedbackTimer?.cancel();
    phase = GamePhase.ended;
  }

  // ───────────── Tray ─────────────

  void addFood(String foodId) {
    if (!acceptsInput) return;
    final q = quantityOf(foodId);
    if (q >= maxQuantityPerFood) return;
    selection[foodId] = q + 1;
    _notify();
  }

  void removeFood(String foodId) {
    if (!acceptsInput) return;
    final q = quantityOf(foodId) - 1;
    // Never negative: zero removes the item from the tray.
    if (q <= 0) {
      selection.remove(foodId);
    } else {
      selection[foodId] = q;
    }
    _notify();
  }

  void clearSelection() {
    if (!acceptsInput || selection.isEmpty) return;
    selection.clear();
    _notify();
  }

  void toggleHint() {
    if (!acceptsInput) return;
    if (!(customer?.order.hintEnabled ?? false)) return;
    hintVisible = !hintVisible;
    _notify();
  }

  // ───────────── Serving ─────────────

  /// Submits the tray. Returns null if input is blocked (prevents double
  /// submission), [FeedbackKind.empty] if nothing is selected.
  FeedbackKind? serve() {
    if (phase != GamePhase.playing) return null;
    final order = customer?.order;
    if (order == null) return null;
    if (selectedCount == 0) return FeedbackKind.empty;

    // Lock immediately so repeated taps are ignored.
    phase = GamePhase.feedback;

    if (order.matches(selection)) {
      correctOrders++;
      streak++;
      if (streak > bestStreak) bestStreak = streak;
      final bonus = streak > 1 ? Scoring.streakBonus : 0;
      final points = Scoring.correctOrder + bonus;
      score += points;
      coinsEarned += Scoring.coinsPerCorrect;
      servedFoods.addAll(order.items.map((i) => i.foodId));
      feedback = OrderFeedback(
        kind: FeedbackKind.correct,
        points: points,
        streakBonus: bonus,
        coins: Scoring.coinsPerCorrect,
      );
    } else {
      wrongOrders++;
      streak = 0;
      score = max(0, score + Scoring.incorrectOrder);
      feedback = const OrderFeedback(
        kind: FeedbackKind.incorrect,
        points: Scoring.incorrectOrder,
      );
    }

    _notify();
    final kind = feedback!.kind;
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(
      const Duration(milliseconds: GameTiming.feedbackMs),
      _afterFeedback,
    );
    return kind;
  }

  void _afterFeedback() {
    if (phase == GamePhase.ended || _disposed) return;
    if (phase == GamePhase.paused) {
      _pendingAfterFeedback = true;
      return;
    }
    if (correctOrders >= level.customerGoal || _remainingMs <= 0 || outOfMistakes) {
      _endLevel();
      return;
    }
    _nextCustomer();
    phase = GamePhase.playing;
    _notify();
  }

  void _nextCustomer() {
    customer = _orders.nextCustomer(level);
    customerSerial++;
    selection.clear();
    feedback = null;
    hintVisible = _progression.settings.showHintByDefault &&
        (customer?.order.hintEnabled ?? false);
  }

  // ───────────── Level end ─────────────

  void _endLevel() {
    if (phase == GamePhase.ended) return;
    phase = GamePhase.ended;
    _ticker?.cancel();
    _feedbackTimer?.cancel();

    final completed = correctOrders >= level.customerGoal;
    final baseScore = score;
    final timeBonus = completed && level.timeBonusEnabled
        ? remainingSeconds.floor() * Scoring.timeBonusPerSecond
        : 0;
    final completionBonus = completed ? Scoring.levelCompletionBonus : 0;
    final finalScore = baseScore + timeBonus + completionBonus;

    var stars = 0;
    if (completed) {
      stars = 1;
      if (finalScore >= level.star2Score) stars = 2;
      if (finalScore >= level.star3Score) stars = 3;
    }
    final coins = coinsEarned + stars * Scoring.coinsPerStar;
    score = finalScore;
    coinsEarned = coins;

    // Recorded once per run.
    finalResult = _progression
        .recordLevelResult(
          level: level,
          score: finalScore,
          stars: stars,
          completed: completed,
          coinsEarned: coins,
          ordersServed: correctOrders + wrongOrders,
          servedFoodIds: servedFoods,
        )
        .then((outcome) => LevelResult(
              level: level,
              completed: completed,
              score: finalScore,
              baseScore: baseScore,
              timeBonus: timeBonus,
              completionBonus: completionBonus,
              correctOrders: correctOrders,
              wrongOrders: wrongOrders,
              bestStreak: bestStreak,
              coinsEarned: coins,
              stars: stars,
              isNewBest: outcome.isNewBest,
              unlockedStateId: outcome.unlockedStateId,
              newFoods: outcome.newFoods,
            ));
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }
}
