import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player_progress.dart';

/// Local persistence using SharedPreferences.
///
/// Progress is written as one JSON document plus a backup copy, so a
/// corrupted write can fall back to the last good save instead of
/// wiping the player's progress.
class StorageService {
  static const _progressKey = 'mco_progress_v1';
  static const _progressBackupKey = 'mco_progress_v1_backup';
  static const _settingsKey = 'mco_settings_v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences?> _instance() async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Storage unavailable: $e');
    }
    return _prefs;
  }

  Future<PlayerProgress> loadProgress() async {
    final prefs = await _instance();
    if (prefs == null) return PlayerProgress();
    for (final key in [_progressKey, _progressBackupKey]) {
      final raw = prefs.getString(key);
      if (raw == null) continue;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return PlayerProgress.fromJson(decoded);
        }
      } catch (e) {
        debugPrint('Corrupt save in $key: $e');
      }
    }
    return PlayerProgress();
  }

  Future<void> saveProgress(PlayerProgress p) async {
    final prefs = await _instance();
    if (prefs == null) return;
    try {
      final previous = prefs.getString(_progressKey);
      if (previous != null) {
        await prefs.setString(_progressBackupKey, previous);
      }
      await prefs.setString(_progressKey, jsonEncode(p.toJson()));
    } catch (e) {
      debugPrint('Failed to save progress: $e');
    }
  }

  Future<GameSettings> loadSettings() async {
    final prefs = await _instance();
    final raw = prefs?.getString(_settingsKey);
    if (raw == null) return GameSettings();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return GameSettings.fromJson(decoded);
    } catch (e) {
      debugPrint('Corrupt settings: $e');
    }
    return GameSettings();
  }

  Future<void> saveSettings(GameSettings s) async {
    final prefs = await _instance();
    try {
      await prefs?.setString(_settingsKey, jsonEncode(s.toJson()));
    } catch (e) {
      debugPrint('Failed to save settings: $e');
    }
  }

  Future<void> clearProgress() async {
    final prefs = await _instance();
    try {
      await prefs?.remove(_progressKey);
      await prefs?.remove(_progressBackupKey);
    } catch (e) {
      debugPrint('Failed to clear progress: $e');
    }
  }
}
