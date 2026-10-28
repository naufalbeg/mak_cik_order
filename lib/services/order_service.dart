import 'dart:math';

import '../data/dialogue_data.dart';
import '../data/foods_data.dart';
import '../models/customer_model.dart';
import '../models/level_model.dart';
import '../models/order_model.dart';
import '../utils/art.dart';

/// Generates customers and their orders from level data.
class OrderService {
  final Random _rng;
  String? _lastSignature;
  String? _lastName;
  String? _lastSprite;

  OrderService([Random? rng]) : _rng = rng ?? Random();

  static const DialectProfile _fallbackProfile = DialectProfile(
    stateId: 'default',
    dialectLabel: 'Bahasa Melayu',
    numberWords: standardNumberWords,
    joinWord: standardJoinWord,
    customerNames: ['Pelanggan'],
    templates: [OrderTemplate('Mak Cik, saya mahu {items}.', 'Mak Cik, saya mahu {items}.')],
  );

  Customer nextCustomer(LevelConfig level) {
    final profile = dialectByState[level.stateId] ?? _fallbackProfile;

    CustomerOrder order;
    var tries = 0;
    do {
      order = _generateOrder(level, profile);
      tries++;
    } while (order.signature() == _lastSignature && tries < 6);
    _lastSignature = order.signature();

    var name = profile.customerNames[_rng.nextInt(profile.customerNames.length)];
    if (name == _lastName && profile.customerNames.length > 1) {
      final others = profile.customerNames.where((n) => n != _lastName).toList();
      name = others[_rng.nextInt(others.length)];
    }
    _lastName = name;

    // Pick a character that is different from the previous customer.
    final sprites = Art.customerSprites.where((s) => s != _lastSprite).toList();
    final sprite = sprites[_rng.nextInt(sprites.length)];
    _lastSprite = sprite;

    return Customer(
      name: name,
      avatar: customerAvatars[_rng.nextInt(customerAvatars.length)],
      sprite: sprite,
      order: order,
    );
  }

  CustomerOrder _generateOrder(LevelConfig level, DialectProfile profile) {
    final pool = level.foodIds.where((id) => foodsById.containsKey(id)).toList()
      ..shuffle(_rng);
    final maxDistinct = min(level.maxDistinctItems, pool.length);
    final distinct = maxDistinct <= 1 ? 1 : 1 + _rng.nextInt(maxDistinct);

    final items = [
      for (final id in pool.take(distinct))
        OrderItem(foodId: id, quantity: 1 + _rng.nextInt(max(1, level.maxQuantity))),
    ];

    final template = profile.templates[_rng.nextInt(profile.templates.length)];
    final local = formatItems(items, profile.numberWords, profile.joinWord);
    final standard = formatItems(items, standardNumberWords, standardJoinWord);

    return CustomerOrder(
      stateId: level.stateId,
      dialectLabel: profile.dialectLabel,
      dialogue: _capitalize(template.dialogue.replaceAll('{items}', local)),
      translationMs: _capitalize(template.translationMs.replaceAll('{items}', standard)),
      items: items,
      hintEnabled: level.hintEnabled,
    );
  }

  /// "dua Akok, satu Jala Mas dan tiga Nekbat"
  static String formatItems(List<OrderItem> items, List<String> numbers, String join) {
    final parts = items.map((i) {
      final food = foodsById[i.foodId];
      final name = food?.name ?? i.foodId;
      final n = (i.quantity >= 1 && i.quantity <= numbers.length)
          ? numbers[i.quantity - 1]
          : '${i.quantity}';
      return '$n $name';
    }).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first;
    return '${parts.sublist(0, parts.length - 1).join(', ')} $join ${parts.last}';
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
