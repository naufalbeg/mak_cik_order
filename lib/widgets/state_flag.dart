import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Simplified, hand-painted flags of the Malaysian states and
/// Kuala Lumpur. Drawn in code so they stay crisp at any size and need
/// no image assets. Details (coats of arms, wreaths) are stylised.
class StateFlag extends StatelessWidget {
  final String stateId;
  final double width;
  final bool greyscale;

  const StateFlag({super.key, required this.stateId, this.width = 48, this.greyscale = false});

  @override
  Widget build(BuildContext context) {
    final height = width * 2 / 3;
    Widget flag = ClipRRect(
      borderRadius: BorderRadius.circular(width * 0.06),
      child: CustomPaint(size: Size(width, height), painter: _FlagPainter(stateId)),
    );
    if (greyscale) {
      flag = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0, 0, 0, 0.6, 0,
        ]),
        child: flag,
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.08),
        border: Border.all(color: Colors.white, width: math.max(1.5, width * 0.04)),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 2))],
      ),
      child: flag,
    );
  }
}

class _FlagPainter extends CustomPainter {
  final String id;
  _FlagPainter(this.id);

  static const _red = Color(0xFFCC0001);
  static const _yellow = Color(0xFFFFCC00);
  static const _blue = Color(0xFF010066);
  static const _black = Color(0xFF111111);
  static const _white = Colors.white;

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    void rect(double l, double t, double r, double b, Color col) =>
        c.drawRect(Rect.fromLTRB(l * w, t * h, r * w, b * h), Paint()..color = col);

    switch (id) {
      case 'kelantan':
        rect(0, 0, 1, 1, _red);
        _crescentStar(c, Offset(w * 0.5, h * 0.42), h * 0.2, _white);
        _spears(c, w, h);
      case 'terengganu':
        rect(0, 0, 1, 1, _white);
        rect(0.08, 0.12, 0.92, 0.88, _black);
        _crescentStar(c, Offset(w * 0.5, h * 0.5), h * 0.22, _white);
      case 'penang':
        rect(0, 0, 1 / 3, 1, const Color(0xFF7FC4F2));
        rect(1 / 3, 0, 2 / 3, 1, _white);
        rect(2 / 3, 0, 1, 1, _yellow);
        _palm(c, Offset(w * 0.5, h * 0.82), h * 0.6);
      case 'melaka':
        rect(0, 0, 1, 0.5, _red);
        rect(0, 0.5, 1, 1, _white);
        rect(0, 0, 0.45, 0.5, _blue);
        _crescentStar(c, Offset(w * 0.22, h * 0.25), h * 0.14, _yellow);
      case 'negeri_sembilan':
        rect(0, 0, 1, 1, _yellow);
        c.drawPath(_tri(w, h, [const Offset(0, 0), const Offset(0.45, 0), const Offset(0, 0.5)]),
            Paint()..color = _red);
        c.drawPath(_tri(w, h, [const Offset(0.45, 0), const Offset(0.45, 0.5), const Offset(0, 0.5)]),
            Paint()..color = _black);
      case 'johor':
        rect(0, 0, 1, 1, _blue);
        rect(0, 0, 0.5, 0.5, _red);
        _crescentStar(c, Offset(w * 0.25, h * 0.25), h * 0.15, _white);
      case 'perak':
        rect(0, 0, 1, 1 / 3, _white);
        rect(0, 1 / 3, 1, 2 / 3, _yellow);
        rect(0, 2 / 3, 1, 1, _black);
      case 'pahang':
        rect(0, 0, 1, 0.5, _white);
        rect(0, 0.5, 1, 1, _black);
      case 'kedah':
        rect(0, 0, 1, 1, _red);
        final wreath = Paint()
          ..color = const Color(0xFF2E8B2E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = h * 0.06;
        c.drawArc(Rect.fromCircle(center: Offset(w * 0.2, h * 0.3), radius: h * 0.18), 0.4, math.pi * 1.6, false,
            wreath);
        _crescentStar(c, Offset(w * 0.2, h * 0.28), h * 0.1, _yellow);
      case 'perlis':
        rect(0, 0, 1, 0.5, _yellow);
        rect(0, 0.5, 1, 1, const Color(0xFF0033A0));
      case 'selangor':
        rect(0, 0, 0.5, 0.5, _red);
        rect(0.5, 0, 1, 0.5, _yellow);
        rect(0, 0.5, 0.5, 1, _yellow);
        rect(0.5, 0.5, 1, 1, _red);
        _crescentStar(c, Offset(w * 0.25, h * 0.25), h * 0.15, _white);
      case 'kuala_lumpur':
        rect(0, 0, 1, 0.48, const Color(0xFF0047AB));
        rect(0, 0.48, 1, 0.52, _white);
        rect(0, 0.52, 1, 1, _red);
        _crescentStar(c, Offset(w * 0.2, h * 0.24), h * 0.14, _yellow);
      case 'sabah':
        rect(0, 0, 1, 0.5, const Color(0xFF6FA8DC));
        rect(0, 0.5, 1, 0.68, _white);
        rect(0, 0.68, 1, 1, _red);
        rect(0, 0, 0.36, 0.68, const Color(0xFF0A2E73));
        c.drawPath(
          _tri(w, h, [
            const Offset(0.03, 0.5),
            const Offset(0.13, 0.22),
            const Offset(0.18, 0.3),
            const Offset(0.22, 0.18),
            const Offset(0.33, 0.5),
          ]),
          Paint()..color = const Color(0xFF6FA8DC),
        );
      case 'sarawak':
        rect(0, 0, 1, 1, _yellow);
        final band = Path()
          ..moveTo(0, h)
          ..lineTo(0, h * 0.62)
          ..lineTo(w * 0.93, 0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.38)
          ..lineTo(w * 0.07, h)
          ..close();
        c.drawPath(band, Paint()..color = _black);
        final inner = Path()
          ..moveTo(0, h * 0.86)
          ..lineTo(w * 0.73, h * 0.0)
          ..lineTo(w, 0)
          ..lineTo(w, h * 0.14)
          ..lineTo(w * 0.27, h)
          ..lineTo(0, h)
          ..close();
        c.drawPath(inner, Paint()..color = _red);
        _star(c, Offset(w * 0.5, h * 0.5), h * 0.16, 9, _yellow);
      default:
        rect(0, 0, 1, 1, Colors.grey);
    }
  }

  Path _tri(double w, double h, List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx * w, pts.first.dy * h);
    for (final o in pts.skip(1)) {
      p.lineTo(o.dx * w, o.dy * h);
    }
    return p..close();
  }

  void _crescentStar(Canvas c, Offset center, double r, Color color) {
    final outer = Path()..addOval(Rect.fromCircle(center: center, radius: r));
    final inner = Path()..addOval(Rect.fromCircle(center: center.translate(r * 0.35, 0), radius: r * 0.82));
    c.drawPath(Path.combine(PathOperation.difference, outer, inner), Paint()..color = color);
    _star(c, center.translate(r * 0.85, 0), r * 0.48, 5, color);
  }

  void _star(Canvas c, Offset center, double r, int points, Color color) {
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? r : r * 0.45;
      final a = -math.pi / 2 + i * math.pi / points;
      final p = center + Offset(math.cos(a) * radius, math.sin(a) * radius);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    c.drawPath(path..close(), Paint()..color = color);
  }

  void _spears(Canvas c, double w, double h) {
    final p = Paint()
      ..color = _white
      ..strokeWidth = h * 0.045
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(w * 0.3, h * 0.85), Offset(w * 0.7, h * 0.65), p);
    c.drawLine(Offset(w * 0.3, h * 0.65), Offset(w * 0.7, h * 0.85), p);
  }

  void _palm(Canvas c, Offset base, double size) {
    final green = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = size * 0.08
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final top = base.translate(0, -size * 0.75);
    c.drawLine(base, top, green);
    for (final dx in [-1.0, -0.5, 0.5, 1.0]) {
      c.drawLine(top, top.translate(dx * size * 0.32, size * (dx.abs() > 0.7 ? 0.12 : -0.08)), green);
    }
  }

  @override
  bool shouldRepaint(covariant _FlagPainter old) => old.id != id;
}
