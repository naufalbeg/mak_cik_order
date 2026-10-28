class OrderItem {
  final String foodId;
  final int quantity;

  const OrderItem({required this.foodId, required this.quantity});
}

/// One customer order. Stores both the local dialogue and its
/// Standard Malay translation as two distinct strings (section 6).
class CustomerOrder {
  final String stateId;
  final String dialectLabel;
  final String dialogue;
  final String translationMs;
  final List<OrderItem> items;
  final bool hintEnabled;

  const CustomerOrder({
    required this.stateId,
    required this.dialectLabel,
    required this.dialogue,
    required this.translationMs,
    required this.items,
    required this.hintEnabled,
  });

  Map<String, int> get asMap => {for (final i in items) i.foodId: i.quantity};

  int get totalQuantity => items.fold(0, (sum, i) => sum + i.quantity);

  /// Compares every food ID and quantity — not just the item count.
  /// Akok × 2 is NOT equal to Akok × 1 + Jala Mas × 1.
  bool matches(Map<String, int> selection) {
    final wanted = asMap;
    final given = {
      for (final e in selection.entries)
        if (e.value > 0) e.key: e.value,
    };
    if (wanted.length != given.length) return false;
    for (final e in wanted.entries) {
      if (given[e.key] != e.value) return false;
    }
    return true;
  }

  String signature() {
    final keys = asMap.keys.toList()..sort();
    return keys.map((k) => '$k:${asMap[k]}').join('|');
  }
}
