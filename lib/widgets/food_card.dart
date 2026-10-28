import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../utils/constants.dart';
import 'food_image.dart';

/// Tappable food choice. Tap adds one to the tray.
class FoodCard extends StatefulWidget {
  final FoodItem food;
  final int quantity;
  final bool enabled;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.quantity,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with SingleTickerProviderStateMixin {
  late final AnimationController _bump = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  @override
  void didUpdateWidget(covariant FoodCard old) {
    super.didUpdateWidget(old);
    if (widget.quantity > old.quantity) _bump.forward(from: 0);
  }

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.quantity > 0;
    return Semantics(
      button: true,
      label: '${widget.food.name}, ${widget.quantity}',
      child: AnimatedBuilder(
        animation: _bump,
        builder: (context, child) {
          final t = _bump.value;
          final scale = 1 + 0.08 * (t < 0.5 ? t * 2 : (1 - t) * 2);
          return Transform.scale(scale: scale, child: child);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: selected
                      ? const [Color(0xFFFFF4CC), Color(0xFFFFE08A)]
                      : const [Colors.white, Color(0xFFFFF3E0)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? AppColors.chili : AppColors.woodDark,
                  width: selected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: fade(AppColors.woodDark, 0.35),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, c) => Center(
                            child: FoodImage(
                              food: widget.food,
                              size: (c.maxHeight < c.maxWidth ? c.maxHeight : c.maxWidth)
                                  .clamp(20.0, 84.0).toDouble(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.food.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  ),
                  if (selected)
                    Positioned(
                      top: -6,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.chili,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '×${widget.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
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
