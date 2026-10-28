import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/customer_model.dart';
import '../models/shop_item.dart';
import '../models/state_model.dart';
import '../services/game_service.dart';
import '../services/progression_service.dart';
import '../utils/art.dart';
import '../utils/constants.dart';

/// The stall scene in the game: state background, awning, signboard,
/// the customer, Mak Cik and the counter. Uses the player's equipped
/// cosmetics (table, decor, apron, signboard, theme tint).
class CustomerPanel extends StatelessWidget {
  final MalaysianState state;
  final Customer? customer;
  final int customerSerial;
  final FeedbackKind? feedback;
  final double height;

  const CustomerPanel({
    super.key,
    required this.state,
    required this.customer,
    required this.customerSerial,
    required this.feedback,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    final mood = switch (feedback) {
      FeedbackKind.correct => 'happy',
      FeedbackKind.incorrect => 'worried',
      _ => 'neutral',
    };
    return StallScene(
      height: height,
      stallName: state.stallName,
      accent: state.primary,
      backgroundAsset: Art.stateBackground(state.id),
      theme: p.equippedItem(ShopCategory.theme),
      table: p.equippedItem(ShopCategory.table),
      deco: p.equippedItem(ShopCategory.decoration),
      apron: p.equippedItem(ShopCategory.clothing),
      sign: p.equippedItem(ShopCategory.signboard),
      makCikMood: mood,
      customer: customer == null
          ? null
          : CustomerFigure(
              key: ValueKey(customerSerial),
              customer: customer!,
              feedback: feedback,
              height: height * 0.6,
            ),
    );
  }
}

/// Reusable stall drawing — also used for the shop preview.
class StallScene extends StatelessWidget {
  final double height;
  final String stallName;
  final Color accent;
  final ShopItem theme;
  final ShopItem table;
  final ShopItem deco;
  final ShopItem apron;
  final ShopItem sign;
  final Widget? customer;

  /// 'neutral', 'happy' or 'worried'
  final String makCikMood;

  /// Scenic background image; when null the theme gradient is used.
  final String? backgroundAsset;

  const StallScene({
    super.key,
    required this.height,
    required this.stallName,
    required this.accent,
    required this.theme,
    required this.table,
    required this.deco,
    required this.apron,
    required this.sign,
    this.customer,
    this.makCikMood = 'neutral',
    this.backgroundAsset,
  });

  @override
  Widget build(BuildContext context) {
    final counterH = height * 0.2;
    final awningH = height * 0.12;
    final themeGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.color, theme.color2],
        ),
      ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.woodDark, width: 3),
        boxShadow: [BoxShadow(color: fade(AppColors.woodDark, 0.3), offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          children: [
            // ── Scenery ──
            Positioned.fill(
              child: backgroundAsset == null
                  ? themeGradient
                  : ArtImage(backgroundAsset!, fit: BoxFit.cover, alignment: Alignment.center, fallback: themeGradient),
            ),
            // Shop theme as a soft colour tint over the scenery.
            if (backgroundAsset != null && theme.id != 'theme_kampung')
              Positioned.fill(child: ColoredBox(color: fade(theme.color, 0.22))),

            // ── Awning ──
            Positioned(top: 0, left: 0, right: 0, height: awningH, child: _Awning(color: accent)),

            // ── Signboard ──
            Positioned(
              top: awningH + 4,
              left: 0,
              right: 0,
              child: Center(child: _Signboard(name: stallName, sign: sign, deco: deco, height: height)),
            ),

            // ── Customer (left) ──
            if (customer != null)
              Positioned(left: 6, bottom: counterH - 8, child: customer!),

            // ── Mak Cik (right, behind the counter) ──
            Positioned(
              right: 4,
              bottom: counterH - 10,
              child: MakCikFigure(mood: makCikMood, apron: apron, height: height * 0.56),
            ),

            // ── Counter ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: counterH,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [table.color, table.color2],
                  ),
                  border: const Border(top: BorderSide(color: AppColors.woodDark, width: 3)),
                ),
                child: CustomPaint(painter: _CounterPainter(batik: table.id == 'table_batik', accent: table.color2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Awning extends StatelessWidget {
  final Color color;
  const _Awning({required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _AwningPainter(color));
}

class _AwningPainter extends CustomPainter {
  final Color color;
  _AwningPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const stripes = 10;
    final w = size.width / stripes;
    final outline = Paint()
      ..color = AppColors.woodDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (var i = 0; i < stripes; i++) {
      final x = i * w;
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + w, 0)
        ..lineTo(x + w, size.height * 0.7)
        ..quadraticBezierTo(x + w / 2, size.height * 1.15, x, size.height * 0.7)
        ..close();
      canvas.drawPath(path, Paint()..color = i.isEven ? color : Colors.white);
      canvas.drawPath(path, outline);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.18), Paint()..color = fade(Colors.black, 0.12));
  }

  @override
  bool shouldRepaint(covariant _AwningPainter old) => old.color != color;
}

class _Signboard extends StatelessWidget {
  final String name;
  final ShopItem sign;
  final ShopItem deco;
  final double height;

  const _Signboard({required this.name, required this.sign, required this.deco, required this.height});

  @override
  Widget build(BuildContext context) {
    final decoText = deco.emoji.isNotEmpty ? Text(deco.emoji, style: TextStyle(fontSize: height * 0.09)) : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (decoText != null) decoText,
        const SizedBox(width: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: sign.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.woodDark, width: 2.5),
            boxShadow: sign.id == 'sign_neon'
                ? [BoxShadow(color: fade(sign.color2, 0.8), blurRadius: 12)]
                : [BoxShadow(color: fade(Colors.black, 0.2), offset: const Offset(0, 3))],
          ),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: sign.color2, fontWeight: FontWeight.w900, fontSize: (height * 0.06).clamp(11.0, 16.0).toDouble()),
          ),
        ),
        const SizedBox(width: 4),
        if (decoText != null) decoText,
      ],
    );
  }
}

class _CounterPainter extends CustomPainter {
  final bool batik;
  final Color accent;
  _CounterPainter({required this.batik, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    // wood planks
    final plank = Paint()
      ..color = fade(Colors.black, 0.12)
      ..strokeWidth = 1.5;
    for (var y = size.height / 3; y < size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), plank);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 4), Paint()..color = fade(Colors.white, 0.35));
    if (batik) {
      final p = Paint()
        ..color = fade(accent, 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      for (var x = 14.0; x < size.width; x += 34) {
        canvas.drawCircle(Offset(x, size.height / 2), size.height * 0.25, p);
        canvas.drawCircle(Offset(x, size.height / 2), size.height * 0.1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CounterPainter old) => old.batik != batik || old.accent != accent;
}

/// Mak Cik illustration with the equipped apron drawn over her clothes.
class MakCikFigure extends StatelessWidget {
  final String mood;
  final ShopItem apron;
  final double height;

  const MakCikFigure({super.key, required this.mood, required this.apron, required this.height});

  @override
  Widget build(BuildContext context) {
    final width = height * 200 / 240;
    final light = apron.color.computeLuminance() > 0.5;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: ArtImage(
                Art.makCik(mood),
                key: ValueKey(mood),
                fit: BoxFit.contain,
                fallback: Center(child: Text('🧕🏽', style: TextStyle(fontSize: height * 0.5))),
              ),
            ),
          ),
          // Apron bib (shop cosmetic)
          Positioned(
            left: width * 0.3,
            right: width * 0.3,
            bottom: 0,
            height: height * 0.2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [apron.color, apron.color2]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(height * 0.05)),
                border: Border.all(color: AppColors.woodDark, width: 2),
              ),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    'MAK CIK',
                    style: TextStyle(fontWeight: FontWeight.w900, color: light ? AppColors.ink : Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A customer that slides in, gently bobs while waiting and reacts
/// (happy / angry) to the served order.
class CustomerFigure extends StatefulWidget {
  final Customer customer;
  final FeedbackKind? feedback;
  final double height;

  const CustomerFigure({super.key, required this.customer, required this.feedback, required this.height});

  @override
  State<CustomerFigure> createState() => _CustomerFigureState();
}

class _CustomerFigureState extends State<CustomerFigure> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  )..forward();

  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _enter.dispose();
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = switch (widget.feedback) {
      FeedbackKind.correct => 'happy',
      FeedbackKind.incorrect => 'angry',
      _ => 'neutral',
    };
    final h = widget.height;
    final w = h * 200 / 240;

    return SlideTransition(
      position: Tween(begin: const Offset(-1.4, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: _enter, curve: Curves.easeOutBack)),
      child: AnimatedBuilder(
        animation: _bob,
        builder: (context, child) {
          // Bounce for happy, shake for angry, gentle bob while waiting.
          final t = _bob.value * 2 * math.pi;
          final dy = mood == 'happy' ? -(math.sin(t * 2).abs() * 6) : math.sin(t) * 2.5;
          final dx = mood == 'angry' ? math.sin(t * 6) * 2.5 : 0.0;
          return Transform.translate(offset: Offset(dx, dy), child: child);
        },
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: ArtImage(
                    Art.customer(widget.customer.sprite, mood),
                    key: ValueKey(mood),
                    fit: BoxFit.contain,
                    fallback: Center(child: Text(widget.customer.avatar, style: TextStyle(fontSize: h * 0.5))),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.woodDark, width: 1.5),
                    ),
                    child: Text(
                      widget.customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.ink),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
