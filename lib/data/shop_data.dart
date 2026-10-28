import '../models/food_model.dart';
import '../models/shop_item.dart';

/// Cosmetic shop catalogue. Items priced 0 are owned from the start.
const List<ShopItem> allShopItems = [
  // Tables
  ShopItem(
    id: 'table_wood',
    category: ShopCategory.table,
    name: LocalizedText('Wooden Table', 'Meja Kayu'),
    price: 0,
    emoji: '🪵',
    colorValue: 0xFF8B5A2B,
    colorValue2: 0xFF5C3A1B,
  ),
  ShopItem(
    id: 'table_pastel',
    category: ShopCategory.table,
    name: LocalizedText('Pastel Table', 'Meja Pastel'),
    price: 120,
    emoji: '🩷',
    colorValue: 0xFFF4A6B8,
    colorValue2: 0xFFC8738A,
  ),
  ShopItem(
    id: 'table_pandan',
    category: ShopCategory.table,
    name: LocalizedText('Pandan Table', 'Meja Pandan'),
    price: 160,
    emoji: '🌿',
    colorValue: 0xFF6DBE5A,
    colorValue2: 0xFF3D7F31,
  ),
  ShopItem(
    id: 'table_batik',
    category: ShopCategory.table,
    name: LocalizedText('Batik Table', 'Meja Batik'),
    price: 250,
    emoji: '🎨',
    colorValue: 0xFF3B5BA9,
    colorValue2: 0xFFF2B705,
  ),

  // Decorations
  ShopItem(
    id: 'deco_none',
    category: ShopCategory.decoration,
    name: LocalizedText('No Decoration', 'Tiada Hiasan'),
    price: 0,
    emoji: '',
    colorValue: 0x00000000,
    colorValue2: 0x00000000,
  ),
  ShopItem(
    id: 'deco_flowers',
    category: ShopCategory.decoration,
    name: LocalizedText('Hibiscus Flowers', 'Bunga Raya'),
    price: 80,
    emoji: '🌺',
    colorValue: 0xFFE53E3E,
    colorValue2: 0xFF2F855A,
  ),
  ShopItem(
    id: 'deco_baskets',
    category: ShopCategory.decoration,
    name: LocalizedText('Food Baskets', 'Bakul Makanan'),
    price: 100,
    emoji: '🧺',
    colorValue: 0xFFB7791F,
    colorValue2: 0xFF744210,
  ),
  ShopItem(
    id: 'deco_lanterns',
    category: ShopCategory.decoration,
    name: LocalizedText('Lanterns', 'Tanglung'),
    price: 150,
    emoji: '🏮',
    colorValue: 0xFFC53030,
    colorValue2: 0xFFF6E05E,
  ),
  ShopItem(
    id: 'deco_ketupat',
    category: ShopCategory.decoration,
    name: LocalizedText('Ketupat Garland', 'Hiasan Ketupat'),
    price: 180,
    emoji: '🎐',
    colorValue: 0xFF38A169,
    colorValue2: 0xFFF6E05E,
  ),

  // Clothing
  ShopItem(
    id: 'apron_plain',
    category: ShopCategory.clothing,
    name: LocalizedText('Plain Apron', 'Apron Biasa'),
    price: 0,
    emoji: '🤍',
    colorValue: 0xFFFFFFFF,
    colorValue2: 0xFFE2E8F0,
  ),
  ShopItem(
    id: 'apron_pandan',
    category: ShopCategory.clothing,
    name: LocalizedText('Pandan Apron', 'Apron Pandan'),
    price: 100,
    emoji: '💚',
    colorValue: 0xFF4E9F3D,
    colorValue2: 0xFF2F6B2A,
  ),
  ShopItem(
    id: 'apron_batik',
    category: ShopCategory.clothing,
    name: LocalizedText('Batik Apron', 'Apron Batik'),
    price: 200,
    emoji: '💙',
    colorValue: 0xFF2B6CB0,
    colorValue2: 0xFFF6AD55,
  ),
  ShopItem(
    id: 'apron_songket',
    category: ShopCategory.clothing,
    name: LocalizedText('Songket Apron', 'Apron Songket'),
    price: 320,
    emoji: '💛',
    colorValue: 0xFF7B2D26,
    colorValue2: 0xFFF2B705,
  ),

  // Signboard
  ShopItem(
    id: 'sign_basic',
    category: ShopCategory.signboard,
    name: LocalizedText('Wooden Signboard', 'Papan Tanda Kayu'),
    price: 0,
    emoji: '🪧',
    colorValue: 0xFFA0703C,
    colorValue2: 0xFFFFF6E5,
  ),
  ShopItem(
    id: 'sign_gold',
    category: ShopCategory.signboard,
    name: LocalizedText('Golden Signboard', 'Papan Tanda Emas'),
    price: 150,
    emoji: '✨',
    colorValue: 0xFFD69E2E,
    colorValue2: 0xFF3B2A1A,
  ),
  ShopItem(
    id: 'sign_neon',
    category: ShopCategory.signboard,
    name: LocalizedText('Neon Signboard', 'Papan Tanda Neon'),
    price: 220,
    emoji: '💡',
    colorValue: 0xFF1A202C,
    colorValue2: 0xFFFF6BD6,
  ),

  // Themes (stall background)
  ShopItem(
    id: 'theme_kampung',
    category: ShopCategory.theme,
    name: LocalizedText('Kampung', 'Kampung'),
    price: 0,
    emoji: '🌴',
    colorValue: 0xFFBEE3A8,
    colorValue2: 0xFFFFF6E5,
  ),
  ShopItem(
    id: 'theme_coastal',
    category: ShopCategory.theme,
    name: LocalizedText('Coastal', 'Pantai'),
    price: 180,
    emoji: '🏖️',
    colorValue: 0xFF90CDF4,
    colorValue2: 0xFFFEEBC8,
  ),
  ShopItem(
    id: 'theme_heritage',
    category: ShopCategory.theme,
    name: LocalizedText('Heritage Town', 'Bandar Warisan'),
    price: 180,
    emoji: '🏘️',
    colorValue: 0xFFFBB6CE,
    colorValue2: 0xFFFEFCBF,
  ),
  ShopItem(
    id: 'theme_night',
    category: ShopCategory.theme,
    name: LocalizedText('Night Market', 'Pasar Malam'),
    price: 260,
    emoji: '🌙',
    colorValue: 0xFF2A4365,
    colorValue2: 0xFF805AD5,
  ),
];

final Map<String, ShopItem> shopItemsById = {
  for (final i in allShopItems) i.id: i,
};

/// Default (free) item per category.
const Map<ShopCategory, String> defaultEquipped = {
  ShopCategory.table: 'table_wood',
  ShopCategory.decoration: 'deco_none',
  ShopCategory.clothing: 'apron_plain',
  ShopCategory.signboard: 'sign_basic',
  ShopCategory.theme: 'theme_kampung',
};
