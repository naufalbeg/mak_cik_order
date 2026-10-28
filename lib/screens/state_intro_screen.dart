import 'package:flutter/material.dart';

import '../app.dart';
import '../data/dialogue_data.dart';
import '../data/foods_data.dart';
import '../data/levels_data.dart';
import '../models/level_model.dart';
import '../models/state_model.dart';
import '../services/order_service.dart';
import '../services/progression_service.dart';
import '../utils/art.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/food_image.dart';
import '../widgets/state_flag.dart';
import 'game_screen.dart';

/// Stall setting, featured food, example dialogue and the level list.
class StateIntroScreen extends StatefulWidget {
  final MalaysianState state;

  const StateIntroScreen({super.key, required this.state});

  @override
  State<StateIntroScreen> createState() => _StateIntroScreenState();
}

class _StateIntroScreenState extends State<StateIntroScreen> {
  late final _example = OrderService().nextCustomer(levelsForState(widget.state.id).first).order;
  bool _showTranslation = false;

  void _play(LevelConfig level) {
    final p = ProgressionService.instance;
    if (!p.isLevelUnlocked(level)) {
      AudioManager.instance.play(Sfx.wrong);
      showToast(context, '🔒 ${tr('locked')}');
      return;
    }
    if (!ensureLives(context)) return;
    Navigator.of(context).push(gameRoute(GameScreen(level: level)));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final p = ProgressionService.instance;
    final levels = levelsForState(s.id);
    final lang = p.lang;
    final dialect = dialectByState[s.id];

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: p,
            builder: (context, _) => Column(
              children: [
                ScreenHeader(title: s.name, trailing: const WalletBadges(size: 14)),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      // State scenery
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.woodDark, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ArtImage(Art.stateBackground(s.id), fit: BoxFit.cover, fallback: ColoredBox(color: s.secondary)),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ArtImage(Art.makCik('happy'), height: 120),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [s.primary, Color.lerp(s.primary, Colors.black, 0.25)!]),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                StateFlag(stateId: s.id, width: 84),
                                const SizedBox(height: 6),
                                Text(s.emoji, style: const TextStyle(fontSize: 26)),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.stallName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.setting.of(lang),
                                    style: TextStyle(color: fade(Colors.white, 0.92), fontSize: 13.5, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle(tr('featured_food')),
                      SizedBox(
                        height: 104,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: s.foodIds.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) {
                            final f = foodById(s.foodIds[i]);
                            if (f == null) return const SizedBox.shrink();
                            return SizedBox(
                              width: 82,
                              child: Column(
                                children: [
                                  FoodImage(food: f, size: 62),
                                  const SizedBox(height: 4),
                                  Text(
                                    f.name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, height: 1.1),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle(tr('example_dialogue')),
                      GestureDetector(
                        onTap: () => setState(() => _showTranslation = !_showTranslation),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.wood, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _example.dialectLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '“${_example.dialogue}”',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 180),
                                crossFadeState:
                                    _showTranslation ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                firstChild: Row(
                                  children: [
                                    const Icon(Icons.lightbulb_rounded, size: 16, color: AppColors.turmeric),
                                    const SizedBox(width: 4),
                                    Text(
                                      tr('hint'),
                                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.wood),
                                    ),
                                  ],
                                ),
                                secondChild: Text(
                                  '${tr('standard_malay')}: ${_example.translationMs}',
                                  style: const TextStyle(color: AppColors.pandanDark, fontSize: 14),
                                ),
                              ),
                              if (dialect != null && !dialect.reviewed) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'ⓘ ${tr('dialogue_draft_note')}',
                                  style: TextStyle(fontSize: 11, color: fade(AppColors.muted, 0.9)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle(tr('choose_level')),
                      for (final level in levels) ...[
                        _LevelCard(
                          level: level,
                          accent: s.primary,
                          unlocked: p.isLevelUnlocked(level),
                          stars: p.starsFor(level.id),
                          best: p.bestScoreFor(level.id),
                          onTap: () => _play(level),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.woodDark),
        ),
      );
}

class _DifficultyChip extends StatelessWidget {
  final Difficulty difficulty;

  const _DifficultyChip(this.difficulty);

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      Difficulty.easy => AppColors.pandan,
      Difficulty.medium => AppColors.turmeric,
      Difficulty.hard => AppColors.chili,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fade(color, 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        tr(difficulty.name),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.ink),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final LevelConfig level;
  final Color accent;
  final bool unlocked;
  final int stars;
  final int best;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.accent,
    required this.unlocked,
    required this.stars,
    required this.best,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: unlocked ? Colors.white : const Color(0xFFEDEDED),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: unlocked ? accent : Colors.grey.shade400, width: 2.5),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: unlocked ? accent : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: unlocked
                    ? Text(
                        '${level.number}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                      )
                    : const Icon(Icons.lock_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          tr('level_n', {'n': '${level.number}'}),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 8),
                        _DifficultyChip(level.difficulty),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tr('goal_customers', {'n': '${level.customerGoal}'})} • '
                      '${tr('seconds', {'n': '${level.durationSeconds}'})}',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.muted, fontWeight: FontWeight.w600),
                    ),
                    if (best > 0)
                      Text(
                        '${tr('best')}: $best',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.pandanDark, fontWeight: FontWeight.w800),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  StarRow(stars: stars, size: 20),
                  const SizedBox(height: 4),
                  Icon(
                    unlocked ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded,
                    color: unlocked ? AppColors.chili : Colors.grey,
                    size: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
