import 'package:flutter/material.dart';

import '../data/foods_data.dart';
import '../data/states_data.dart';
import '../models/food_model.dart';
import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/food_image.dart';

/// Recipe book of every food, grouped by state. Entries unlock when the
/// dish is served correctly for the first time.
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  void _open(BuildContext context, FoodItem food, bool discovered) {
    AudioManager.instance.play(Sfx.tap);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => _FoodDetail(food: food, discovered: discovered),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    final found = allFoods.where((f) => p.isFoodDiscovered(f.id)).length;
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              ScreenHeader(
                title: tr('collection'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.pandan,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    tr('discovered_x', {'n': '$found', 'total': '${allFoods.length}'}),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    for (final s in allStates) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Row(
                            children: [
                              Text(s.emoji, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                s.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: s.primary),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Divider(color: fade(s.primary, 0.4), thickness: 2)),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 130,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.82,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final food = foodById(s.foodIds[i]);
                              if (food == null) return const SizedBox.shrink();
                              final discovered = p.isFoodDiscovered(food.id);
                              return _CollectionTile(
                                food: food,
                                discovered: discovered,
                                onTap: () => _open(context, food, discovered),
                              );
                            },
                            childCount: s.foodIds.length,
                          ),
                        ),
                      ),
                    ],
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'ⓘ ${tr('shared_note')}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  final FoodItem food;
  final bool discovered;
  final VoidCallback onTap;

  const _CollectionTile({required this.food, required this.discovered, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: discovered ? Colors.white : const Color(0xFFEDE7DC),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: discovered ? AppColors.turmeric : AppColors.creamDark, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FoodImage(food: food, size: 58, locked: !discovered),
              const SizedBox(height: 6),
              Text(
                discovered ? food.name : '???',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                  height: 1.1,
                  color: discovered ? AppColors.ink : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodDetail extends StatelessWidget {
  final FoodItem food;
  final bool discovered;

  const _FoodDetail({required this.food, required this.discovered});

  @override
  Widget build(BuildContext context) {
    final lang = ProgressionService.instance.lang;
    final state = statesById[food.stateId];
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 14),
              Center(child: FoodImage(food: food, size: 110, locked: !discovered)),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  discovered ? food.name : tr('undiscovered'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.woodDark),
                ),
              ),
              if (state != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${state.emoji} ${tr('region')}: ${state.name}',
                      style: TextStyle(color: state.primary, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (!discovered)
                Text(
                  tr('undiscovered_hint'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppColors.muted),
                )
              else ...[
                Text(food.description.of(lang), style: const TextStyle(fontSize: 15.5, height: 1.4)),
                const SizedBox(height: 16),
                Text(
                  tr('ingredients'),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.woodDark),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final ing in food.ingredients)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.creamDark),
                        ),
                        child: Text(ing, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6E4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 ${tr('cultural_fact')}',
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.pandanDark),
                      ),
                      const SizedBox(height: 4),
                      Text(food.culturalFact.of(lang), style: const TextStyle(height: 1.4)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
