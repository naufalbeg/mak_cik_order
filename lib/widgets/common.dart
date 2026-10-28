import 'dart:async';

import 'package:flutter/material.dart';

import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';

/// Chunky, tactile button used across menus.
class GameButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadow;
  final Color textColor;
  final double height;
  final double fontSize;
  final bool playSound;

  const GameButton({
    super.key,
    required this.label,
    this.icon,
    this.emoji,
    this.onPressed,
    this.color = AppColors.pandan,
    this.shadow = AppColors.pandanDark,
    this.textColor = Colors.white,
    this.height = 56,
    this.fontSize = 18,
    this.playSound = true,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final color = enabled ? widget.color : Colors.grey.shade400;
    final shadow = enabled ? widget.shadow : Colors.grey.shade600;
    const depth = 5.0;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapCancel: enabled ? () => setState(() => _down = false) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTap: enabled
            ? () {
                if (widget.playSound) AudioManager.instance.play(Sfx.tap);
                widget.onPressed!();
              }
            : null,
        child: SizedBox(
          height: widget.height + depth,
          child: Stack(
            children: [
              Positioned.fill(
                top: depth,
                child: Container(
                  decoration: BoxDecoration(
                    color: shadow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 60),
                left: 0,
                right: 0,
                top: _down ? depth : 0,
                height: widget.height,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: fade(Colors.white, 0.35), width: 2),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.emoji != null) ...[
                          Text(widget.emoji!, style: TextStyle(fontSize: widget.fontSize + 6)),
                          const SizedBox(width: 10),
                        ] else if (widget.icon != null) ...[
                          Icon(widget.icon, color: widget.textColor, size: widget.fontSize + 6),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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

class CoinBadge extends StatelessWidget {
  final int? amount;
  final double size;

  const CoinBadge({super.key, this.amount, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) => Container(
        padding: EdgeInsets.symmetric(horizontal: size * 0.7, vertical: size * 0.3),
        decoration: BoxDecoration(
          color: AppColors.woodDark,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.turmeric, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🪙', style: TextStyle(fontSize: size)),
            SizedBox(width: size * 0.35),
            Text(
              '${amount ?? p.coins}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatCountdown(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
}

/// Hearts left plus a countdown to the full refill while not full.
class LifeBadge extends StatefulWidget {
  final double size;

  const LifeBadge({super.key, this.size = 16});

  @override
  State<LifeBadge> createState() => _LifeBadgeState();
}

class _LifeBadgeState extends State<LifeBadge> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      ProgressionService.instance.tickLives();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    final size = widget.size;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final refillIn = p.livesRefillIn;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.7, vertical: size * 0.3),
          decoration: BoxDecoration(
            color: AppColors.woodDark,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.chili, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('❤️', style: TextStyle(fontSize: size)),
              SizedBox(width: size * 0.35),
              Text(
                refillIn == null ? '${p.lives}' : '${p.lives} · ${formatCountdown(refillIn)}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: size,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Returns true if the player may start a level; otherwise explains why not.
bool ensureLives(BuildContext context) {
  final p = ProgressionService.instance;
  if (p.hasLives) return true;
  AudioManager.instance.play(Sfx.wrong);
  showToast(
    context,
    '💔 ${tr('no_lives', {'time': formatCountdown(p.livesRefillIn ?? Duration.zero)})}',
    color: AppColors.chili,
  );
  return false;
}

/// Coins and lives side by side, for screen headers.
class WalletBadges extends StatelessWidget {
  final double size;

  const WalletBadges({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LifeBadge(size: size),
          SizedBox(width: size * 0.4),
          CoinBadge(size: size),
        ],
      );
}

class StarRow extends StatelessWidget {
  final int stars;
  final double size;
  final int max;

  const StarRow({super.key, required this.stars, this.size = 18, this.max = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        max,
        (i) => Icon(
          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < stars ? AppColors.turmeric : fade(AppColors.wood, 0.45),
        ),
      ),
    );
  }
}

/// Cream background with a subtle batik-like dot pattern.
class PatternBackground extends StatelessWidget {
  final Widget child;
  final Color base;
  final Color dot;

  const PatternBackground({
    super.key,
    required this.child,
    this.base = AppColors.cream,
    this.dot = AppColors.creamDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotPainter(base, dot),
      child: child,
    );
  }
}

class _DotPainter extends CustomPainter {
  final Color base;
  final Color dot;

  _DotPainter(this.base, this.dot);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final p = Paint()..color = dot;
    const step = 28.0;
    var row = 0;
    for (var y = 10.0; y < size.height; y += step) {
      final offset = row.isEven ? 0.0 : step / 2;
      for (var x = 10.0 + offset; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 2.4, p);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter old) =>
      old.base != base || old.dot != dot;
}

/// Header bar for sub-screens.
class ScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const ScreenHeader({super.key, required this.title, this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            iconSize: 28,
            onPressed: onBack ??
                () {
                  AudioManager.instance.play(Sfx.tap);
                  Navigator.of(context).maybePop();
                },
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.woodDark),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.woodDark,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Confirmation dialog helper.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      content: body == null ? null : Text(body, style: const TextStyle(color: AppColors.ink)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: destructive ? AppColors.chili : AppColors.pandan,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showToast(BuildContext context, String message, {Color color = AppColors.woodDark}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ));
}

/// Warm "stall signboard" panel used in place of plain white cards:
/// kraft-paper body, wooden frame and an optional hanging title board.
class StallPanel extends StatelessWidget {
  final Widget child;
  final String? title;
  final IconData? icon;
  final Color accent;
  final EdgeInsetsGeometry margin;

  const StallPanel({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.accent = AppColors.wood,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFBE7C0), Color(0xFFF1D29A)],
        ),
        border: Border.all(color: accent, width: 3),
        boxShadow: [BoxShadow(color: fade(AppColors.woodDark, 0.45), offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.turmeric, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          Padding(padding: const EdgeInsets.all(14), child: child),
        ],
      ),
    );
  }
}
