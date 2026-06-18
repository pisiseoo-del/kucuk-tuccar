import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class GameRepository {
  static const _key = 'game_state_v1';
  Future<GameState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return const GameState();
    try { return GameState.fromJsonString(json); } catch (_) { return const GameState(); }
  }
  Future<void> save(GameState s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, s.toJsonString());
  }
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
