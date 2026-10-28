import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app.dart';
import '../services/progression_service.dart';
import '../data/foods_data.dart';
import '../utils/art.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/food_image.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/state_flag.dart';
import '../data/states_data.dart';
import 'collection_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';
import 'splash_screen.dart';
import 'state_map_screen.dart';
import 'tutorial_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _exit(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: tr('exit_confirm'),
      confirmLabel: tr('yes'),
      cancelLabel: tr('no'),
    );
    if (ok) SystemNavigator.pop();
  }

  void _go(BuildContext context, Widget page) => Navigator.of(context).push(gameRoute(page));

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFE8C2),
        body: Stack(
          children: [
            // Illustrated kampung sunset backdrop
            const Positioned.fill(
              child: ArtImage(
                Art.home,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                fallback: PatternBackground(child: SizedBox.expand()),
              ),
            ),
            SafeArea(
              child: ListenableBuilder(
                listenable: p,
                builder: (context, _) => LayoutBuilder(
                  builder: (context, c) {
                    final compact = c.maxHeight < 680;
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: c.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const _TopBar(),
                                  SizedBox(height: compact ? 10 : 18),
                                  GameLogo(size: compact ? 0.72 : 0.9, showMascot: false),
                                  SizedBox(height: compact ? 6 : 12),
                                  _HeroStall(height: compact ? 170 : 220),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _MenuPanel(
                                children: [
                                  _StateProgress(p: p),
                                  const SizedBox(height: 12),
                                  GameButton(
                                    label: p.hasAnyProgress ? tr('continue') : tr('play'),
                                    emoji: '🍛',
                                    height: 64,
                                    fontSize: 24,
                                    color: const Color(0xFFE8503A),
                                    shadow: const Color(0xFF9E2B21),
                                    onPressed: () => _go(context, const StateMapScreen()),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GameButton(
                                          label: tr('collection'),
                                          emoji: '📖',
                                          fontSize: 15,
                                          color: const Color(0xFF8E5BD8),
                                          shadow: const Color(0xFF5B3494),
                                          onPressed: () => _go(context, const CollectionScreen()),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: GameButton(
                                          label: tr('shop'),
                                          emoji: '🛒',
                                          fontSize: 15,
                                          color: const Color(0xFFF08A24),
                                          shadow: const Color(0xFFA85A0E),
                                          onPressed: () => _go(context, const ShopScreen()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _IconTile(
                                        emoji: '❓',
                                        label: tr('how_to_play'),
                                        color: const Color(0xFF3FA34D),
                                        onTap: () => _go(context, const TutorialScreen()),
                                      ),
                                      const SizedBox(width: 10),
                                      _IconTile(
                                        emoji: '⚙️',
                                        label: tr('settings'),
                                        color: const Color(0xFF2E9BD6),
                                        onTap: () => _go(context, const SettingsScreen()),
                                      ),
                                      const SizedBox(width: 10),
                                      _IconTile(
                                        emoji: '👋',
                                        label: tr('exit'),
                                        color: const Color(0xFF6B7A8F),
                                        onTap: () => _exit(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mak Cik waving behind her stall counter with some signature dishes.
class _HeroStall extends StatefulWidget {
  final double height;
  const _HeroStall({required this.height});

  @override
  State<_HeroStall> createState() => _HeroStallState();
}

class _HeroStallState extends State<_HeroStall> with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  static const _dishes = ['nasi_lemak', 'satay', 'cendol', 'roti_canai'];

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final counterH = h * 0.26;
    return SizedBox(
      height: h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Mak Cik
          Positioned(
            bottom: counterH - 12,
            child: AnimatedBuilder(
              animation: _bob,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -4 * Curves.easeInOut.transform(_bob.value)),
                child: child,
              ),
              child: ArtImage(
                Art.makCik('happy'),
                height: h * 0.8,
                fallback: Text('🧕🏽', style: TextStyle(fontSize: h * 0.45)),
              ),
            ),
          ),
          // Counter
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: counterH,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB0723A), Color(0xFF7A4A22)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.woodDark, width: 3),
                boxShadow: [BoxShadow(color: fade(Colors.black, 0.3), offset: const Offset(0, 5))],
              ),
            ),
          ),
          // Dishes on the counter
          Positioned(
            left: 8,
            right: 8,
            bottom: counterH * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final id in _dishes)
                  if (foodById(id) != null) FoodImage(food: foodById(id)!, size: h * 0.26),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuPanel extends StatelessWidget {
  final List<Widget> children;
  const _MenuPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: fade(AppColors.cream, 0.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.woodDark, width: 3),
        boxShadow: [BoxShadow(color: fade(Colors.black, 0.25), offset: const Offset(0, 6), blurRadius: 6)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// Row of state flags; completed states are shown in colour.
class _StateProgress extends StatelessWidget {
  final ProgressionService p;
  const _StateProgress({required this.p});

  @override
  Widget build(BuildContext context) {
    final done = allStates.where((s) => p.isStateCompleted(s.id)).length;
    return Column(
      children: [
        Row(
          children: [
            const Text('🗺️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                tr('map_title'),
                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.woodDark),
              ),
            ),
            Text(
              '$done/${allStates.length}',
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.pandanDark),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            for (final s in allStates)
              Tooltip(
                message: s.name,
                child: StateFlag(stateId: s.id, width: 30, greyscale: !p.isStateCompleted(s.id)),
              ),
          ],
        ),
      ],
    );
  }
}

/// Small square button with an emoji and a label.
class _IconTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _IconTile({required this.emoji, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AudioManager.instance.play(Sfx.tap);
            onTap();
          },
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.woodDark, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact header: avatar, greeting, stars and coins.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    final name = p.settings.playerName ?? '';
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      decoration: BoxDecoration(
        color: fade(Colors.white, 0.85),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.turmeric, width: 2),
        boxShadow: [BoxShadow(color: fade(AppColors.woodDark, 0.25), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showEditProfileSheet(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AvatarCircle(avatar: p.settings.avatar, size: 44),
                const Positioned(
                  right: -3,
                  bottom: -3,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: AppColors.pandanDark,
                    child: Icon(Icons.edit_rounded, size: 11, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name.isEmpty ? tr('app_title') : tr('welcome_back', {'name': name}),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.woodDark),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: fade(AppColors.turmeric, 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '⭐ ${p.totalStars}/${p.maxStars}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
          ),
          const SizedBox(width: 6),
          const LifeBadge(size: 13),
          const SizedBox(width: 6),
          const CoinBadge(size: 13),
        ],
      ),
    );
  }
}
