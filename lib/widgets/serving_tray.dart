import 'package:flutter/material.dart';

import '../data/foods_data.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import 'food_image.dart';

/// Shows the selected foods with +/− quantity controls and Clear.
class ServingTray extends StatelessWidget {
  final Map<String, int> selection;
  final bool enabled;
  final void Function(String foodId) onAdd;
  final void Function(String foodId) onRemove;
  final VoidCallback onClear;

  const ServingTray({
    super.key,
    required this.selection,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final entries = selection.entries.where((e) => e.value > 0).toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 6, 8),
      decoration: BoxDecoration(
        // Wooden serving board
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC8935A), Color(0xFFA8733E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.woodDark, width: 3),
        boxShadow: [BoxShadow(color: fade(AppColors.woodDark, 0.3), offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                tr('tray'),
                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: fade(AppColors.chili, 0.85),
                  disabledForegroundColor: fade(Colors.white, 0.5),
                  disabledBackgroundColor: fade(Colors.black, 0.1),
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(44, 36),
                ),
                onPressed: enabled && entries.isNotEmpty ? onClear : null,
                icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                label: Text(tr('clear'), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          SizedBox(
            height: 52,
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      tr('tray_empty'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: fade(Colors.white, 0.9), fontWeight: FontWeight.w700),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final e = entries[i];
                      final food = foodById(e.key);
                      if (food == null) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.only(left: 4, right: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: AppColors.woodDark, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FoodImage(food: food, size: 36),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 84),
                              child: Text(
                                food.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: enabled ? () => onRemove(e.key) : null,
                            ),
                            Text(
                              '${e.value}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: enabled ? () => onAdd(e.key) : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 44,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 22,
        color: AppColors.woodDark,
        onPressed: onTap,
        icon: Icon(icon),
      ),
    );
  }
}
