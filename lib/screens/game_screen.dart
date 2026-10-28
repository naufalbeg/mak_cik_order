import 'dart:math';

import 'package:flutter/material.dart';

import '../app.dart';
import '../data/foods_data.dart';
import '../data/states_data.dart';
import '../models/food_model.dart';
import '../models/level_model.dart';
import '../models/state_model.dart';
import '../services/game_service.dart';
import '../services/progression_service.dart';
import '../utils/art.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/customer_panel.dart';
import '../widgets/food_card.dart';
import '../widgets/order_dialogue.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/serving_tray.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final LevelConfig level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late GameSession _session;
  late final MalaysianState _state = statesById[widget.level.stateId]!;
  late final List<FoodItem> _foods =
      widget.level.foodIds.map(foodById).whereType<FoodItem>().toList();

  bool _navigating = false;
  int _lastWarnSecond = -1;
  String? _endBanner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _createSession();
  }

  void _createSession() {
    _session = GameSession(widget.level);
    _session.addListener(_onSessionChanged);
    _lastWarnSecond = -1;
  }

  void _disposeSession() {
    _session.removeListener(_onSessionChanged);
    _session.abandon();
    _session.dispose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeSession();
    super.dispose();
  }

  /// App going to background pauses gameplay and timer.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _session.pause();
    }
  }

  // Side effects only — the UI rebuilds through ListenableBuilder.
  void _onSessionChanged() {
    final s = _session;
    if (s.acceptsInput) {
      final sec = s.remainingSeconds.ceil();
      if (sec <= 5 && sec > 0 && sec != _lastWarnSecond) {
        _lastWarnSecond = sec;
        AudioManager.instance.play(Sfx.tick);
      }
    }
    if (s.isEnded && !_navigating && s.finalResult != null) {
      _goToResult();
    }
  }

  Future<void> _goToResult() async {
    _navigating = true;
    final completed = _session.correctOrders >= widget.level.customerGoal;
    setState(() => _endBanner = completed
        ? tr('goal_reached')
        : _session.outOfMistakes
            ? tr('too_many_wrong')
            : tr('times_up'));
    final results = await Future.wait([
      _session.finalResult!,
      Future<void>.delayed(const Duration(milliseconds: 1000)),
    ]);
    if (!mounted) return;
    final result = results.first as LevelResult;
    Navigator.of(context).pushReplacement(gameRoute(ResultScreen(result: result)));
  }

  void _start() {
    AudioManager.instance.play(Sfx.tap);
    _session.start();
  }

  void _serve() {
    final kind = _session.serve();
    switch (kind) {
      case null:
        return;
      case FeedbackKind.empty:
        AudioManager.instance.play(Sfx.wrong);
        showToast(context, tr('select_food_first'), color: AppColors.chili);
        break;
      case FeedbackKind.correct:
        AudioManager.instance.play(Sfx.correct);
        Future.delayed(const Duration(milliseconds: 250), () => AudioManager.instance.play(Sfx.coin));
        AudioManager.instance.vibrate();
        break;
      case FeedbackKind.incorrect:
        AudioManager.instance.play(Sfx.wrong);
        AudioManager.instance.vibrate(strong: true);
        break;
    }
  }

  void _pause() {
    AudioManager.instance.play(Sfx.tap);
    _session.pause();
  }

  Future<void> _restart() async {
    final ok = await confirmDialog(
      context,
      title: tr('restart_confirm_title'),
      body: tr('life_cost_note'),
      confirmLabel: tr('restart'),
      cancelLabel: tr('cancel'),
    );
    if (!ok || !mounted) return;
    await ProgressionService.instance.spendLife();
    if (!mounted) return;
    if (!ensureLives(context)) {
      _session.abandon();
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _disposeSession();
      _createSession();
    });
  }

  Future<void> _toMainMenu() async {
    final ok = await confirmDialog(
      context,
      title: tr('quit_confirm_title'),
      body: tr('life_cost_note'),
      confirmLabel: tr('main_menu'),
      cancelLabel: tr('cancel'),
      destructive: true,
    );
    if (!ok || !mounted) return;
    _session.abandon();
    await ProgressionService.instance.spendLife();
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _handleBack() {
    switch (_session.phase) {
      case GamePhase.ready:
        Navigator.of(context).pop();
        break;
      case GamePhase.playing:
      case GamePhase.feedback:
        _session.pause();
        break;
      case GamePhase.paused:
        _toMainMenu();
        break;
      case GamePhase.ended:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: PatternBackground(
          child: SafeArea(
            child: ListenableBuilder(
              listenable: _session,
              builder: (context, _) {
                final s = _session;
                final input = s.acceptsInput;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final sceneH = (c.maxHeight * 0.25).clamp(130.0, 240.0).toDouble();
                          return Column(
                            children: [
                              _Hud(
                                title: '${_state.name} • ${tr('level_n', {'n': '${widget.level.number}'})}',
                                accent: _state.primary,
                                secondsLeft: s.remainingSeconds,
                                timeFraction: s.timeFraction,
                                score: s.score,
                                coins: s.coinsEarned,
                                served: s.correctOrders,
                                goal: widget.level.customerGoal,
                                streak: s.streak,
                                wrong: s.wrongOrders,
                                onPause: s.phase == GamePhase.playing || s.phase == GamePhase.feedback ? _pause : null,
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CustomerPanel(
                                    state: _state,
                                    customer: s.customer,
                                    customerSerial: s.customerSerial,
                                    feedback: s.feedback?.kind,
                                    height: sceneH,
                                  ),
                                  if (s.feedback != null && s.phase != GamePhase.ready)
                                    Positioned(
                                      top: sceneH * 0.22,
                                      left: 0,
                                      right: 0,
                                      child: _FeedbackPop(key: ValueKey('fb${s.customerSerial}'), feedback: s.feedback!),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (s.customer != null)
                                OrderDialogue(
                                  key: ValueKey('dlg${s.customerSerial}'),
                                  order: s.customer!.order,
                                  hintVisible: s.hintVisible,
                                  enabled: input,
                                  onToggleHint: () {
                                    AudioManager.instance.play(Sfx.tap);
                                    s.toggleHint();
                                  },
                                ),
                              const SizedBox(height: 8),
                              ServingTray(
                                selection: s.selection,
                                enabled: input,
                                onAdd: (id) {
                                  AudioManager.instance.play(Sfx.add);
                                  s.addFood(id);
                                },
                                onRemove: (id) {
                                  AudioManager.instance.play(Sfx.remove);
                                  s.removeFood(id);
                                },
                                onClear: () {
                                  AudioManager.instance.play(Sfx.remove);
                                  s.clearSelection();
                                },
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _FoodGrid(
                                  foods: _foods,
                                  quantityOf: s.quantityOf,
                                  enabled: input,
                                  onTap: (id) {
                                    AudioManager.instance.play(Sfx.add);
                                    s.addFood(id);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              GameButton(
                                label: tr('serve'),
                                emoji: '🍽️',
                                height: 58,
                                fontSize: 22,
                                color: AppColors.chili,
                                shadow: const Color(0xFF9E2B21),
                                playSound: false,
                                onPressed: input ? _serve : null,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (_endBanner != null) _EndBanner(text: _endBanner!),
                    if (s.phase == GamePhase.ready)
                      _ReadyOverlay(level: widget.level, state: _state, onStart: _start),
                    if (s.isPaused)
                      PauseOverlay(
                        onResume: () {
                          AudioManager.instance.play(Sfx.tap);
                          s.resume();
                        },
                        onRestart: _restart,
                        onMainMenu: _toMainMenu,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── HUD ─────────────────────────

class _Hud extends StatelessWidget {
  final String title;
  final Color accent;
  final double secondsLeft;
  final double timeFraction;
  final int score;
  final int coins;
  final int served;
  final int goal;
  final int streak;
  final int wrong;
  final VoidCallback? onPause;

  const _Hud({
    required this.wrong,
    required this.title,
    required this.accent,
    required this.secondsLeft,
    required this.timeFraction,
    required this.score,
    required this.coins,
    required this.served,
    required this.goal,
    required this.streak,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppColors.woodDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.turmeric, width: 2),
        boxShadow: [BoxShadow(color: fade(Colors.black, 0.25), offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          _RoundButton(icon: Icons.pause_rounded, onTap: onPause),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                _ProgressDots(served: served, goal: goal),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _Pill(text: '⭐ $score'),
                    const SizedBox(width: 5),
                    _Pill(text: '🪙 +$coins'),
                    const SizedBox(width: 5),
                    _Pill(
                      text: '❌ $wrong/${GameSession.maxWrongOrders}',
                      highlight: wrong >= GameSession.maxWrongOrders - 1,
                    ),
                    if (streak >= 2) ...[
                      const SizedBox(width: 5),
                      _Pill(text: '🔥 ×$streak', highlight: true),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _TimerRing(fraction: timeFraction, seconds: secondsLeft),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.turmeric,
      shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 2)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 44, height: 44, child: Icon(icon, color: AppColors.woodDark, size: 28)),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final bool highlight;
  const _Pill({required this.text, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: highlight ? AppColors.chili : fade(Colors.white, 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}

/// One dot per customer in the level goal; filled when served.
class _ProgressDots extends StatelessWidget {
  final int served;
  final int goal;
  const _ProgressDots({required this.served, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < goal; i++)
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 3),
              height: 9,
              constraints: const BoxConstraints(maxWidth: 26),
              decoration: BoxDecoration(
                color: i < served ? AppColors.pandan : fade(Colors.white, 0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: i < served ? const Color(0xFFB8F0A0) : fade(Colors.white, 0.3)),
              ),
            ),
          ),
      ],
    );
  }
}

class _TimerRing extends StatelessWidget {
  final double fraction;
  final double seconds;
  const _TimerRing({required this.fraction, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final low = seconds <= 10;
    final color = low
        ? AppColors.chili
        : fraction < 0.5
            ? AppColors.turmeric
            : AppColors.pandan;
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.cream, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: fraction,
              strokeWidth: 6,
              backgroundColor: fade(AppColors.wood, 0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '${seconds.ceil()}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: low ? AppColors.chili : AppColors.woodDark),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Food grid ─────────────────────────

class _FoodGrid extends StatelessWidget {
  final List<FoodItem> foods;
  final int Function(String) quantityOf;
  final bool enabled;
  final void Function(String) onTap;

  const _FoodGrid({
    required this.foods,
    required this.quantityOf,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const cols = 3;
        const spacing = 8.0;
        final rows = max(1, (foods.length / cols).ceil());
        final cellW = (c.maxWidth - spacing * (cols - 1)) / cols;
        final available = (c.maxHeight - spacing * (rows - 1)) / rows;
        final fits = available >= 78;
        final cellH = fits ? min(available, 140.0) : 100.0;
        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: fits ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: cellW / cellH,
          ),
          itemCount: foods.length,
          itemBuilder: (context, i) {
            final f = foods[i];
            return FoodCard(
              food: f,
              quantity: quantityOf(f.id),
              enabled: enabled,
              onTap: () => onTap(f.id),
            );
          },
        );
      },
    );
  }
}

// ───────────────────────── Overlays ─────────────────────────

/// Ribbon that pops over the stall after serving, then floats up.
class _FeedbackPop extends StatefulWidget {
  final OrderFeedback feedback;
  const _FeedbackPop({super.key, required this.feedback});

  @override
  State<_FeedbackPop> createState() => _FeedbackPopState();
}

class _FeedbackPopState extends State<_FeedbackPop> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: GameTiming.feedbackMs),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feedback;
    final correct = f.kind == FeedbackKind.correct;
    final color = correct ? AppColors.pandan : AppColors.chili;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = _c.value;
          final scale = Curves.elasticOut.transform((t * 2.5).clamp(0.0, 1.0).toDouble());
          final opacity = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25);
          return Opacity(
            opacity: opacity.clamp(0.0, 1.0).toDouble(),
            child: Transform.translate(
              offset: Offset(0, -24 * t),
              child: Transform.scale(scale: 0.4 + 0.6 * scale, child: child),
            ),
          );
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: fade(Colors.black, 0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  correct ? tr('correct') : tr('incorrect'),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Text(
                  correct ? '+${f.points}   🪙 +${f.coins}' : '${f.points}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                ),
                if (f.streakBonus > 0)
                  Text(
                    '🔥 ${tr('streak_bonus', {'n': '${f.streakBonus}'})}',
                    style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EndBanner extends StatelessWidget {
  final String text;
  const _EndBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: fade(Colors.black, 0.45),
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.4, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.turmeric,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.woodDark, width: 4),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.woodDark),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadyOverlay extends StatelessWidget {
  final LevelConfig level;
  final MalaysianState state;
  final VoidCallback onStart;

  const _ReadyOverlay({required this.level, required this.state, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onStart,
        child: Container(
          color: fade(Colors.black, 0.55),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.woodDark, width: 4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // State scenery with a waving Mak Cik
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ArtImage(
                            Art.stateBackground(state.id),
                            fit: BoxFit.cover,
                            fallback: ColoredBox(color: state.secondary),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ArtImage(
                              Art.makCik('happy'),
                              height: 120,
                              fallback: const Text('🧕🏽', style: TextStyle(fontSize: 64)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 4, color: state.primary),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                    child: Column(
                      children: [
                        Text(
                          '${state.name} • ${tr('level_n', {'n': '${level.number}'})}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.woodDark),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _InfoChip(icon: '🎯', text: tr('goal_customers', {'n': '${level.customerGoal}'})),
                            const SizedBox(width: 8),
                            _InfoChip(icon: '⏱️', text: tr('seconds', {'n': '${level.durationSeconds}'})),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          tr('ready'),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.chili),
                        ),
                        const SizedBox(height: 10),
                        GameButton(
                          label: tr('start'),
                          emoji: '🍛',
                          color: AppColors.pandan,
                          shadow: AppColors.pandanDark,
                          onPressed: onStart,
                          playSound: false,
                        ),
                      ],
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

class _InfoChip extends StatelessWidget {
  final String icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 2),
        ),
        child: Text(
          '$icon $text',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
