import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();
  final AudioPlayer _bgm = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    await _bgm.setReleaseMode(ReleaseMode.loop);
    await _bgm.setVolume(0.4);
    await _sfx.setVolume(0.8);
    if (_musicEnabled) _playBgm();
  }

  Future<void> _playBgm() async {
    try { await _bgm.play(AssetSource('audio/bgm.mp3')); } catch (_) {}
  }

  Future<void> toggleMusic(bool v) async {
    _musicEnabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', v);
    if (v) { _playBgm(); } else { await _bgm.stop(); }
  }

  Future<void> toggleSound(bool v) async {
    _soundEnabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', v);
  }

  Future<void> playCatch()   => _play('audio/sfx_catch.mp3');
  Future<void> playSell()    => _play('audio/sfx_sell.mp3');
  Future<void> playBuy()     => _play('audio/sfx_buy.mp3');
  Future<void> playSuccess() => _play('audio/sfx_success.mp3');
  Future<void> playError()   => _play('audio/sfx_error.mp3');

  Future<void> _play(String a) async {
    if (!_soundEnabled) return;
    try { await _sfx.play(AssetSource(a)); } catch (_) {}
  }
}
