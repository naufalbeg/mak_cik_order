import 'order_model.dart';

class Customer {
  final String name;

  /// Emoji used only if the character art is missing.
  final String avatar;

  /// Character art id, e.g. 'pakcik' → assets/images/characters/pakcik_happy.png
  final String sprite;
  final CustomerOrder order;

  const Customer({
    required this.name,
    required this.avatar,
    required this.order,
    this.sprite = 'pakcik',
  });
}
