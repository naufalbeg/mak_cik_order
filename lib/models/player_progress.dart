import '../utils/constants.dart';

class GameSettings {
  bool music;
  bool sfx;
  bool vibration;
  bool showHintByDefault;

  /// 'ms' (Bahasa Melayu) or 'en' (English).
  String language;
  bool tutorialSeen;

  /// Local player account, created once on first launch.
  String? playerName;
  String avatar;

  bool get isRegistered => playerName != null && playerName!.isNotEmpty;

  GameSettings({
    this.music = true,
    this.sfx = true,
    this.vibration = true,
    this.showHintByDefault = false,
    this.language = 'ms',
    this.tutorialSeen = false,
    this.playerName,
    this.avatar = '🧑🏽',
  });

  Map<String, dynamic> toJson() => {
        'music': music,
        'sfx': sfx,
        'vibration': vibration,
        'showHintByDefault': showHintByDefault,
        'language': language,
        'tutorialSeen': tutorialSeen,
        'playerName': playerName,
        'avatar': avatar,
      };

  factory GameSettings.fromJson(Map<String, dynamic> j) => GameSettings(
        music: j['music'] as bool? ?? true,
        sfx: j['sfx'] as bool? ?? true,
        vibration: j['vibration'] as bool? ?? true,
        showHintByDefault: j['showHintByDefault'] as bool? ?? false,
        language: (j['language'] as String?) == 'en' ? 'en' : 'ms',
        tutorialSeen: j['tutorialSeen'] as bool? ?? false,
        playerName: j['playerName'] as String?,
        avatar: j['avatar'] as String? ?? '🧑🏽',
      );
}

int _nonNegative(int v) => v < 0 ? 0 : v;

class PlayerProgress {
  int coins;
  int totalServed;
  final Set<String> completedLevels;
  final Map<String, int> bestScores;
  final Map<String, int> stars;
  final Set<String> ownedItems;

  /// category name -> item id
  final Map<String, String> equipped;
  final Set<String> discoveredFoods;

  /// Lives left; losing a level costs one. Refills to full at [livesRefillAt].
  int lives;

  /// Epoch ms when lives refill to full, or null while lives are full.
  int? livesRefillAt;

  PlayerProgress({
    this.lives = Lives.max,
    this.livesRefillAt,
    this.coins = 0,
    this.totalServed = 0,
    Set<String>? completedLevels,
    Map<String, int>? bestScores,
    Map<String, int>? stars,
    Set<String>? ownedItems,
    Map<String, String>? equipped,
    Set<String>? discoveredFoods,
  })  : completedLevels = completedLevels ?? <String>{},
        bestScores = bestScores ?? <String, int>{},
        stars = stars ?? <String, int>{},
        ownedItems = ownedItems ?? <String>{},
        equipped = equipped ?? <String, String>{},
        discoveredFoods = discoveredFoods ?? <String>{};

  Map<String, dynamic> toJson() => {
        'version': 1,
        'coins': coins,
        'totalServed': totalServed,
        'completedLevels': completedLevels.toList(),
        'bestScores': bestScores,
        'stars': stars,
        'ownedItems': ownedItems.toList(),
        'equipped': equipped,
        'discoveredFoods': discoveredFoods.toList(),
        'lives': lives,
        'livesRefillAt': livesRefillAt,
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> j) {
    Set<String> strSet(Object? v) =>
        v is List ? v.whereType<String>().toSet() : <String>{};
    Map<String, int> intMap(Object? v) => v is Map
        ? {
            for (final e in v.entries)
              if (e.value is num) e.key.toString(): (e.value as num).toInt(),
          }
        : <String, int>{};
    Map<String, String> strMap(Object? v) => v is Map
        ? {
            for (final e in v.entries)
              if (e.value is String) e.key.toString(): e.value as String,
          }
        : <String, String>{};

    return PlayerProgress(
      coins: _nonNegative((j['coins'] as num?)?.toInt() ?? 0),
      totalServed: (j['totalServed'] as num?)?.toInt() ?? 0,
      completedLevels: strSet(j['completedLevels']),
      bestScores: intMap(j['bestScores']),
      stars: intMap(j['stars']),
      ownedItems: strSet(j['ownedItems']),
      equipped: strMap(j['equipped']),
      discoveredFoods: strSet(j['discoveredFoods']),
      lives: ((j['lives'] as num?)?.toInt() ?? Lives.max).clamp(0, Lives.max),
      livesRefillAt: (j['livesRefillAt'] as num?)?.toInt(),
    );
  }
}
