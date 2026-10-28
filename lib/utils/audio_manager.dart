import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/progression_service.dart';

enum Sfx {
  tap('tap.wav'),
  add('add.wav'),
  remove('remove.wav'),
  correct('correct.wav'),
  wrong('wrong.wav'),
  coin('coin.wav'),
  levelWin('level_win.wav'),
  levelLose('level_lose.wav'),
  tick('tick.wav');

  final String file;
  const Sfx(this.file);
}

/// Music and sound effects. Every call is guarded so a missing or
/// unsupported audio file never crashes the game.
class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  AudioPlayer? _music;
  final List<AudioPlayer> _sfxPool = [];
  int _nextSfx = 0;
  bool _musicPlaying = false;
  bool _suspended = false;

  bool get _musicOn => ProgressionService.instance.settings.music;
  bool get _sfxOn => ProgressionService.instance.settings.sfx;
  bool get _vibrationOn => ProgressionService.instance.settings.vibration;

  Future<void> init() async {
    try {
      _music = AudioPlayer();
      await _music!.setReleaseMode(ReleaseMode.loop);
      await _music!.setVolume(0.35);
      for (var i = 0; i < 4; i++) {
        final p = AudioPlayer();
        await p.setReleaseMode(ReleaseMode.stop);
        _sfxPool.add(p);
      }
    } catch (e) {
      debugPrint('Audio init failed: $e');
    }
  }

  Future<void> play(Sfx sfx) async {
    if (!_sfxOn || _sfxPool.isEmpty) return;
    try {
      final p = _sfxPool[_nextSfx];
      _nextSfx = (_nextSfx + 1) % _sfxPool.length;
      await p.stop();
      await p.play(AssetSource('audio/${sfx.file}'), volume: 0.8);
    } catch (e) {
      debugPrint('SFX ${sfx.file} failed: $e');
    }
  }

  Future<void> startMusic() async {
    if (!_musicOn || _suspended || _musicPlaying || _music == null) return;
    try {
      _musicPlaying = true;
      await _music!.play(AssetSource('audio/bgm.wav'));
    } catch (e) {
      _musicPlaying = false;
      debugPrint('Music failed: $e');
    }
  }

  Future<void> stopMusic() async {
    _musicPlaying = false;
    try {
      await _music?.stop();
    } catch (_) {}
  }

  /// Called when the music toggle changes.
  Future<void> syncWithSettings() async {
    if (_musicOn) {
      await startMusic();
    } else {
      await stopMusic();
    }
  }

  /// App went to background.
  Future<void> suspend() async {
    _suspended = true;
    try {
      await _music?.pause();
    } catch (_) {}
  }

  /// App returned to foreground.
  Future<void> resumeFromBackground() async {
    _suspended = false;
    if (!_musicOn) return;
    try {
      if (_musicPlaying) {
        await _music?.resume();
      } else {
        await startMusic();
      }
    } catch (_) {}
  }

  void vibrate({bool strong = false}) {
    if (!_vibrationOn) return;
    try {
      if (strong) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (_) {}
  }
}
