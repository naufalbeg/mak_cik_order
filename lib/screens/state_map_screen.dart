import 'package:flutter/material.dart';

import '../app.dart';
import '../data/states_data.dart';
import '../models/state_model.dart';
import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/state_flag.dart';
import 'state_intro_screen.dart';

// ───────────── Map geometry ─────────────
//
// The map is laid out on a 1000 × 1900 virtual canvas, scaled to the
// screen width. Peninsular Malaysia sits on top and Malaysian Borneo
// below it (the South China Sea is compressed so the whole country fits
// a portrait screen). Coordinates are real longitude/latitude, simplified.

const double _vw = 1000;
const double _vh = 1900;

Offset _pen(double lon, double lat) => Offset((lon - 99.0) * 166, (7.2 - lat) * 166);
Offset _bor(double lon, double lat) => Offset((lon - 109.4) * 100, 1200 + (7.4 - lat) * 100);

final List<Offset> _peninsulaOutline = [
  for (final p in const [
    (100.13, 6.70), (100.65, 6.45), (101.10, 6.25), (101.60, 5.95), (102.10, 6.22),
    (102.60, 5.85), (103.10, 5.30), (103.45, 4.60), (103.40, 3.90), (103.45, 2.90),
    (103.85, 2.40), (104.25, 1.60), (104.00, 1.35), (103.50, 1.27), (103.20, 1.60),
    (102.60, 2.00), (102.20, 2.30), (101.80, 2.60), (101.30, 2.95), (100.90, 3.60),
    (100.60, 4.20), (100.35, 4.60), (100.35, 5.20), (100.35, 5.90), (100.10, 6.40),
  ])
    _pen(p.$1, p.$2),
];

final List<Offset> _borneoOutline = [
  for (final p in const [
    (109.65, 2.05), (110.00, 1.40), (110.60, 0.90), (111.50, 1.00), (112.20, 1.40),
    (112.90, 1.50), (113.60, 1.20), (114.50, 1.50), (114.60, 2.50), (115.20, 2.90),
    (115.60, 4.00), (116.00, 4.20), (117.50, 4.20), (117.90, 4.15), (118.60, 4.40),
    (119.25, 5.10), (118.30, 5.85), (117.70, 6.50), (117.00, 7.00), (116.70, 6.90),
    (116.00, 6.00), (115.40, 5.30), (115.35, 5.00), (115.10, 4.40), (114.60, 4.00),
    (114.10, 4.60), (113.00, 3.20), (112.00, 2.85), (111.20, 1.90), (110.40, 1.70),
  ])
    _bor(p.$1, p.$2),
];

/// Sabah / Sarawak boundary, drawn as a dashed line.
final List<Offset> _sabahSarawakBorder = [_bor(115.35, 5.0), _bor(115.6, 4.3), _bor(116.0, 4.2)];

class _Pin {
  final Offset point; // where the state is
  final Offset badge; // centre of its flag badge
  const _Pin(this.point, this.badge);
}

final Map<String, _Pin> _pins = {
  'perlis': _Pin(_pen(100.2, 6.45), const Offset(330, 70)),
  'kedah': _Pin(_pen(100.6, 5.9), const Offset(130, 215)),
  'penang': _Pin(_pen(100.3, 5.4), const Offset(130, 370)),
  'perak': _Pin(_pen(101.0, 4.7), const Offset(150, 525)),
  'kelantan': _Pin(_pen(102.0, 5.4), const Offset(600, 170)),
  'terengganu': _Pin(_pen(102.9, 4.9), const Offset(870, 320)),
  'pahang': _Pin(_pen(102.6, 3.7), const Offset(850, 560)),
  'selangor': _Pin(_pen(101.45, 3.2), const Offset(150, 680)),
  'kuala_lumpur': _Pin(_pen(101.7, 3.14), const Offset(200, 840)),
  'negeri_sembilan': _Pin(_pen(102.1, 2.8), const Offset(330, 1000)),
  'melaka': _Pin(_pen(102.3, 2.25), const Offset(600, 1080)),
  'johor': _Pin(_pen(103.4, 2.0), const Offset(860, 1010)),
  'sarawak': _Pin(_bor(112.5, 2.3), const Offset(250, 1520)),
  'sabah': _Pin(_bor(116.8, 5.3), const Offset(820, 1290)),
};

// ───────────── Screen ─────────────

/// Malaysia map with every state pinned at its real location, marked by
/// its flag. Locked states are greyed out with a padlock.
class StateMapScreen extends StatefulWidget {
  const StateMapScreen({super.key});

  @override
  State<StateMapScreen> createState() => _StateMapScreenState();
}

class _StateMapScreenState extends State<StateMapScreen> {
  final _transform = TransformationController();
  double _scale = 1;
  double _viewportHeight = 0;
  bool _scrolled = false;

  void _scrollToCurrent() {
    if (_scrolled || _viewportHeight == 0) return;
    _scrolled = true;
    final current = ProgressionService.instance.continueLevel.stateId;
    final pin = _pins[current];
    if (pin == null) return;
    final maxY = (_vh * _scale - _viewportHeight).clamp(0.0, double.infinity);
    final y = (pin.badge.dy * _scale - _viewportHeight / 2).clamp(0.0, maxY);
    _transform.value = Matrix4.translationValues(0, -y, 0);
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _open(MalaysianState s) {
    final p = ProgressionService.instance;
    if (!p.isStateUnlocked(s.id)) {
      AudioManager.instance.play(Sfx.wrong);
      final idx = stateIndexOf(s.id);
      final prev = idx > 0 ? allStates[idx - 1].name : '';
      showToast(context, '🔒 ${tr('unlock_hint', {'state': prev})}');
      return;
    }
    AudioManager.instance.play(Sfx.tap);
    Navigator.of(context).push(gameRoute(StateIntroScreen(state: s)));
  }

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAE6),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: p,
          builder: (context, _) {
            final unlocked = allStates.where((s) => p.isStateUnlocked(s.id)).length;
            final completed = allStates.where((s) => p.isStateCompleted(s.id)).length;
            final currentId = p.continueLevel.stateId;
            return Column(
              children: [
                Container(
                  color: AppColors.cream,
                  child: Column(
                    children: [
                      ScreenHeader(title: tr('map_title'), trailing: const WalletBadges(size: 14)),
                      _ProgressStrip(completed: completed, total: allStates.length),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      _scale = c.maxWidth / _vw;
                      _viewportHeight = c.maxHeight;
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
                      final badgeW = (_scale * 250).clamp(84.0, 120.0);
                      return InteractiveViewer(
                        transformationController: _transform,
                        constrained: false,
                        minScale: 1,
                        maxScale: 3,
                        boundaryMargin: EdgeInsets.zero,
                        child: SizedBox(
                          width: c.maxWidth,
                          height: _vh * _scale,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _MapPainter(
                                    scale: _scale,
                                    order: [for (final s in allStates) _pins[s.id]!.point],
                                    unlockedCount: unlocked,
                                    stateColors: {
                                      for (final s in allStates)
                                        s.id: p.isStateUnlocked(s.id) ? s.primary : Colors.grey.shade500,
                                    },
                                  ),
                                ),
                              ),
                              _SeaLabel(
                                text: tr('peninsular'),
                                at: const Offset(420, 530),
                                scale: _scale,
                                color: AppColors.woodDark,
                              ),
                              _SeaLabel(text: 'Laut China Selatan', at: const Offset(560, 1200), scale: _scale),
                              _SeaLabel(text: 'Selat Melaka', at: const Offset(110, 1130), scale: _scale),
                              _SeaLabel(
                                text: tr('borneo'),
                                at: const Offset(560, 1740),
                                scale: _scale,
                                color: AppColors.woodDark,
                              ),
                              for (final s in allStates)
                                Positioned(
                                  left: _pins[s.id]!.badge.dx * _scale - badgeW / 2,
                                  top: _pins[s.id]!.badge.dy * _scale - badgeW * 0.36,
                                  width: badgeW,
                                  child: _StateBadge(
                                    state: s,
                                    number: stateIndexOf(s.id) + 1,
                                    unlocked: p.isStateUnlocked(s.id),
                                    completed: p.isStateCompleted(s.id),
                                    stars: p.starsForState(s.id),
                                    isCurrent: currentId == s.id,
                                    width: badgeW,
                                    onTap: () => _open(s),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  final int completed;
  final int total;
  const _ProgressStrip({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          const Text('🇲🇾', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : completed / total,
                minHeight: 10,
                backgroundColor: AppColors.creamDark,
                color: AppColors.pandan,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            tr('states_done', {'n': '$completed', 'total': '$total'}),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.woodDark),
          ),
        ],
      ),
    );
  }
}

class _SeaLabel extends StatelessWidget {
  final String text;
  final Offset at;
  final double scale;
  final Color color;

  const _SeaLabel({
    required this.text,
    required this.at,
    required this.scale,
    this.color = const Color(0xFF1D5C7A),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: at.dx * scale - 100,
      top: at.dy * scale - 10,
      width: 200,
      child: IgnorePointer(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fade(color, 0.75),
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _StateBadge extends StatelessWidget {
  final MalaysianState state;
  final int number;
  final bool unlocked;
  final bool completed;
  final bool isCurrent;
  final int stars;
  final double width;
  final VoidCallback onTap;

  const _StateBadge({
    required this.state,
    required this.number,
    required this.unlocked,
    required this.completed,
    required this.isCurrent,
    required this.stars,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = unlocked ? state.primary : Colors.grey.shade500;
    final flagW = width * 0.46;
    return Semantics(
      button: true,
      label: '${state.name}${unlocked ? '' : ', ${tr('locked')}'}',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (isCurrent)
                  Container(
                    width: flagW + 16,
                    height: flagW * 2 / 3 + 16,
                    decoration: BoxDecoration(
                      color: fade(AppColors.turmeric, 0.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                StateFlag(stateId: state.id, width: flagW, greyscale: !unlocked),
                if (!unlocked) Icon(Icons.lock_rounded, color: Colors.white, size: flagW * 0.4),
                if (completed)
                  const Positioned(
                    right: -8,
                    top: -8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.pandan,
                      child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
                    ),
                  ),
                Positioned(
                  left: -8,
                  top: -8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: accent,
                    child: Text(
                      '$number',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                state.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
              ),
            ),
            if (unlocked)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: fade(Colors.white, 0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: AppColors.turmeric),
                    Text(
                      '$stars/9',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final double scale;
  final List<Offset> order;
  final int unlockedCount;
  final Map<String, Color> stateColors;

  _MapPainter({
    required this.scale,
    required this.order,
    required this.unlockedCount,
    required this.stateColors,
  });

  Path _poly(List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx * scale, pts.first.dy * scale);
    for (final o in pts.skip(1)) {
      p.lineTo(o.dx * scale, o.dy * scale);
    }
    return p..close();
  }

  void _dashed(Canvas c, Path path, Paint paint, double dash, double gap) {
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        c.drawPath(m.extractPath(d, (d + dash).clamp(0, m.length).toDouble()), paint);
        d += dash + gap;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Sea with soft gradient and wave marks.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9ED8F0), Color(0xFF6BB8DD)],
        ).createShader(Offset.zero & size),
    );
    final wave = Paint()
      ..color = fade(Colors.white, 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (var y = 30.0; y < size.height; y += 70) {
      for (var x = (y ~/ 70).isEven ? 20.0 : 55.0; x < size.width; x += 90) {
        canvas.drawArc(Rect.fromLTWH(x, y, 14, 8), 3.4, 2.6, false, wave);
        canvas.drawArc(Rect.fromLTWH(x + 12, y, 14, 8), 3.4, 2.6, false, wave);
      }
    }

    // Land: shadow, beach rim, then land.
    for (final outline in [_peninsulaOutline, _borneoOutline]) {
      final path = _poly(outline);
      canvas.drawPath(path.shift(const Offset(0, 5)), Paint()..color = fade(const Color(0xFF1D5C7A), 0.25));
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFF4E1B5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9BD27A), Color(0xFF5FAE4E)],
          ).createShader(path.getBounds()),
      );
    }
    _dashed(
      canvas,
      Path()
        ..addPolygon([for (final o in _sabahSarawakBorder) o * scale], false),
      Paint()
        ..color = fade(Colors.white, 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
      6,
      5,
    );

    // Journey route through the states unlocked so far.
    for (var i = 0; i < unlockedCount - 1 && i < order.length - 1; i++) {
      final a = order[i] * scale, b = order[i + 1] * scale;
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2) + const Offset(18, -10);
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, b.dx, b.dy);
      _dashed(
        canvas,
        path,
        Paint()
          ..color = AppColors.chili
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
        7,
        6,
      );
    }

    // Leader lines from each badge to the state's location, and its dot.
    final ids = _pins.keys.toList();
    for (final id in ids) {
      final pin = _pins[id]!;
      final color = stateColors[id] ?? Colors.grey;
      final a = pin.point * scale, b = pin.badge * scale;
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = fade(color, 0.8)
          ..strokeWidth = 1.6,
      );
      canvas.drawCircle(a, 6, Paint()..color = Colors.white);
      canvas.drawCircle(a, 4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) =>
      old.scale != scale || old.unlockedCount != unlockedCount || old.stateColors.toString() != stateColors.toString();
}
