import 'package:flutter/material.dart';

import '../data/shop_data.dart';
import '../models/shop_item.dart';
import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/customer_panel.dart';

/// Spend coins on cosmetic stall items and equip owned ones.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const _categories = [
    (ShopCategory.table, 'cat_table'),
    (ShopCategory.decoration, 'cat_decoration'),
    (ShopCategory.clothing, 'cat_clothing'),
    (ShopCategory.signboard, 'cat_signboard'),
    (ShopCategory.theme, 'cat_theme'),
  ];

  Future<void> _onItem(BuildContext context, ShopItem item) async {
    final p = ProgressionService.instance;
    if (p.owns(item.id)) {
      if (!p.isEquipped(item)) {
        AudioManager.instance.play(Sfx.tap);
        await p.equip(item);
      }
      return;
    }
    if (p.coins < item.price) {
      AudioManager.instance.play(Sfx.wrong);
      showToast(context, '🪙 ${tr('not_enough_coins')}', color: AppColors.chili);
      return;
    }
    final lang = p.lang;
    final ok = await confirmDialog(
      context,
      title: tr('buy'),
      body: tr('buy_confirm', {'item': item.name.of(lang), 'price': '${item.price}'}),
      confirmLabel: tr('buy'),
      cancelLabel: tr('cancel'),
    );
    if (!ok) return;
    final result = await p.buy(item);
    if (!context.mounted) return;
    switch (result) {
      case PurchaseResult.success:
        AudioManager.instance.play(Sfx.coin);
        showToast(context, '✨ ${tr('purchased')}', color: AppColors.pandan);
        break;
      case PurchaseResult.insufficientCoins:
        AudioManager.instance.play(Sfx.wrong);
        showToast(context, tr('not_enough_coins'), color: AppColors.chili);
        break;
      case PurchaseResult.alreadyOwned:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        body: PatternBackground(
          child: SafeArea(
            child: ListenableBuilder(
              listenable: p,
              builder: (context, _) => Column(
                children: [
                  ScreenHeader(title: tr('shop'), trailing: const CoinBadge()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StallScene(
                      height: 170,
                      stallName: 'Gerai Mak Cik',
                      accent: AppColors.chili,
                      theme: p.equippedItem(ShopCategory.theme),
                      table: p.equippedItem(ShopCategory.table),
                      deco: p.equippedItem(ShopCategory.decoration),
                      apron: p.equippedItem(ShopCategory.clothing),
                      sign: p.equippedItem(ShopCategory.signboard),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'ⓘ ${tr('cosmetic_note')}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.woodDark,
                    unselectedLabelColor: AppColors.muted,
                    indicatorColor: AppColors.chili,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w900),
                    tabs: [for (final c in _categories) Tab(text: tr(c.$2))],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (final c in _categories)
                          ListView(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                            children: [
                              for (final item in allShopItems.where((i) => i.category == c.$1))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _ShopTile(
                                    item: item,
                                    owned: p.owns(item.id),
                                    equipped: p.isEquipped(item),
                                    affordable: p.coins >= item.price,
                                    onTap: () => _onItem(context, item),
                                  ),
                                ),
                            ],
                          ),
                      ],
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

class _ShopTile extends StatelessWidget {
  final ShopItem item;
  final bool owned;
  final bool equipped;
  final bool affordable;
  final VoidCallback onTap;

  const _ShopTile({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.affordable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = ProgressionService.instance.lang;
    final String actionLabel;
    final Color actionColor;
    if (equipped) {
      actionLabel = tr('equipped');
      actionColor = AppColors.pandan;
    } else if (owned) {
      actionLabel = tr('equip');
      actionColor = AppColors.wood;
    } else {
      actionLabel = item.price == 0 ? tr('free') : '🪙 ${item.price}';
      actionColor = affordable ? AppColors.chili : Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: equipped ? AppColors.pandan : AppColors.creamDark, width: equipped ? 3 : 2),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: item.colorValue == 0
                    ? [AppColors.creamDark, AppColors.cream]
                    : [item.color, item.color2],
              ),
            ),
            child: Text(item.emoji.isEmpty ? '∅' : item.emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name.of(lang),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: actionColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: equipped ? null : onTap,
              child: Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
