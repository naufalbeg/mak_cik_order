import 'package:flutter/material.dart';

import '../data/foods_data.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import 'food_image.dart';

/// Speech bubble with the customer's local dialogue. The Hint button
/// reveals the Standard Malay translation plus pictures of the foods
/// and quantities ordered.
class OrderDialogue extends StatelessWidget {
  final CustomerOrder order;
  final bool hintVisible;
  final bool enabled;
  final VoidCallback onToggleHint;

  const OrderDialogue({
    super.key,
    required this.order,
    required this.hintVisible,
    required this.enabled,
    required this.onToggleHint,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 20, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: fade(AppColors.turmeric, 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🗣️ ${order.dialectLabel}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.woodDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '“${order.dialogue}”',
                        style: const TextStyle(fontSize: 16.5, height: 1.25, fontWeight: FontWeight.w900, color: AppColors.ink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _HintButton(
                  visible: hintVisible,
                  available: order.hintEnabled,
                  enabled: enabled,
                  onTap: onToggleHint,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: hintVisible ? _Hint(order: order) : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final CustomerOrder order;
  const _Hint({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6E4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fade(AppColors.pandan, 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(text: '${tr('standard_malay')}: ', style: const TextStyle(fontWeight: FontWeight.w900)),
              TextSpan(text: order.translationMs),
            ]),
            style: const TextStyle(fontSize: 13.5, color: AppColors.pandanDark),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final item in order.items)
                if (foodById(item.foodId) != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(3, 2, 8, 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.creamDark, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FoodImage(food: foodById(item.foodId)!, size: 26),
                        const SizedBox(width: 3),
                        Text(
                          '×${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.chili),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

/// White speech bubble with a tail pointing up-left at the customer.
class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const r = 18.0;
    const tailTop = 0.0;
    const bodyTop = 10.0;
    final body = RRect.fromRectAndRadius(Rect.fromLTWH(0, bodyTop, size.width, size.height - bodyTop), const Radius.circular(r));
    final tail = Path()
      ..moveTo(40, bodyTop + 2)
      ..lineTo(52, tailTop)
      ..lineTo(66, bodyTop + 2)
      ..close();
    final shape = Path.combine(PathOperation.union, Path()..addRRect(body), tail);

    canvas.drawPath(shape.shift(const Offset(0, 4)), Paint()..color = fade(AppColors.woodDark, 0.25));
    canvas.drawPath(shape, Paint()..color = Colors.white);
    canvas.drawPath(
      shape,
      Paint()
        ..color = AppColors.woodDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HintButton extends StatelessWidget {
  final bool visible;
  final bool available;
  final bool enabled;
  final VoidCallback onTap;

  const _HintButton({
    required this.visible,
    required this.available,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!available) {
      return Tooltip(
        message: tr('hint_unavailable'),
        child: const Icon(Icons.lightbulb_outline, color: Colors.grey),
      );
    }
    return Material(
      color: visible ? AppColors.pandan : AppColors.turmeric,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minWidth: 60, minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.woodDark, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                visible ? Icons.visibility_off_rounded : Icons.lightbulb_rounded,
                size: 20,
                color: visible ? Colors.white : AppColors.ink,
              ),
              Text(
                visible ? tr('hide_hint') : tr('hint'),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: visible ? Colors.white : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
