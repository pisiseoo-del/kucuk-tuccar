import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/audio_manager.dart';
import '../../game/game_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = AudioManager.instance.soundEnabled;
  bool _music = AudioManager.instance.musicEnabled;
  @override
  Widget build(BuildContext context) {
    final game = context.read<GameProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(title: const Text('⚙️  Ayarlar'), leading: const BackButton(color: Color(0xFF9090AA))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _Section('Ses & Müzik', [
          SwitchListTile(title: const Text('Ses Efektleri', style: TextStyle(color: Color(0xFFF0F0FF), fontWeight: FontWeight.w600)),
            value: _sound, activeColor: const Color(0xFF39FF14),
            onChanged: (v) async { await AudioManager.instance.toggleSound(v); setState(() => _sound = v); }),
          SwitchListTile(title: const Text('Arka Plan Müziği', style: TextStyle(color: Color(0xFFF0F0FF), fontWeight: FontWeight.w600)),
            value: _music, activeColor: const Color(0xFF39FF14),
            onChanged: (v) async { await AudioManager.instance.toggleMusic(v); setState(() => _music = v); }),
        ]),
        const SizedBox(height: 20),
        _Section('Oyun', [
          ListTile(
            title: const Text('Oyunu Sıfırla', style: TextStyle(color: Color(0xFFF44336), fontWeight: FontWeight.w700)),
            leading: const Text('🗑️', style: TextStyle(fontSize: 22)),
            onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF14141F),
              title: const Text('Emin misin?', style: TextStyle(color: Color(0xFFF0F0FF))),
              content: const Text('Tüm ilerleme silinecek.', style: TextStyle(color: Color(0xFF9090AA))),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                TextButton(onPressed: () { game.resetGame(); Navigator.pop(context); Navigator.pop(context); },
                  child: const Text('Sıfırla', style: TextStyle(color: Color(0xFFF44336)))),
              ],
            )),
          ),
        ]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.glassCard(), child: const Column(children: [
          Text('Küçük Tüccar', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFF0F0FF))),
          SizedBox(height: 4),
          Text('v1.0.0 · %100 Çevrimdışı', style: TextStyle(color: Color(0xFF9090AA), fontSize: 13)),
          SizedBox(height: 4),
          Text('Made with 💚 Flutter', style: TextStyle(color: Color(0xFF39FF14), fontSize: 12)),
        ])),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF9090AA), letterSpacing: 1.5)),
    const SizedBox(height: 10),
    Container(decoration: AppTheme.glassCard(), child: Column(children: children)),
  ]);
}
