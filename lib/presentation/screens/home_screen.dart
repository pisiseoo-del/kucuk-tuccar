import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../game/game_provider.dart';
import '../painters/background_painter.dart';
import '../widgets/day_header.dart';
import 'harvest_screen.dart';
import 'market_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    context.read<GameProvider>().init();
  }
  @override void dispose() { _bgCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    if (game.loading) return const Scaffold(backgroundColor: Color(0xFF0A0A14), body: Center(child: CircularProgressIndicator(color: Color(0xFF39FF14))));
    final produce = game.todayProduce;
    return Scaffold(
      body: Stack(children: [
        if (produce != null) ...[
          AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => CustomPaint(size: MediaQuery.of(context).size, painter: BackgroundPainter(produce: produce, animValue: _bgCtrl.value))),
          AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => ParticleLayer(produce: produce, animValue: _bgCtrl.value)),
        ],
        SafeArea(child: Column(children: [
          DayHeader(onSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          const SizedBox(height: 12),
          if (produce != null) _ProduceCard(produce: produce),
          const SizedBox(height: 20),
          Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _Btn(emoji:'🌾', label:'HASAT ET', sub: produce?.nameTr ?? '', color: const Color(0xFF39FF14),
                onTap: () => produce == null ? null : Navigator.push(context, MaterialPageRoute(builder: (_) => HarvestScreen(produce: produce)))),
            const SizedBox(height: 14),
            _Btn(emoji:'🏪', label:'HAL\'A GİT', sub:'Ürünleri sat', color: const Color(0xFF3BF0E4),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen()))),
            const SizedBox(height: 14),
            _Btn(emoji:'🛒', label:'KÖYPARAZI', sub:'Ekipman al', color: const Color(0xFFFFD700),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()))),
            const SizedBox(height: 24),
            GestureDetector(onTap: game.advanceDay, child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: AppTheme.neonButton(const Color(0xFF39FF14)),
              child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.wb_sunny_rounded, color: Color(0xFF0A0A14), size: 20),
                SizedBox(width: 8),
                Text('SONRAKİ GÜN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0A0A14), letterSpacing: 2)),
              ])),
            )),
          ]))),
        ])),
      ]),
    );
  }
}

class _ProduceCard extends StatelessWidget {
  final ProduceItem produce;
  const _ProduceCard({required this.produce});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: AppTheme.glassCard(borderColor: const Color(0x6639FF14)),
    child: Row(children: [
      Text(produce.emoji, style: const TextStyle(fontSize: 40)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Bugünün Ürünü', style: Theme.of(context).textTheme.bodyMedium),
        Text(produce.nameTr, style: Theme.of(context).textTheme.titleLarge),
        Text(produce.originTr, style: const TextStyle(fontSize: 12, color: Color(0xFF39FF14))),
      ])),
    ]),
  );
}

class _Btn extends StatelessWidget {
  final String emoji, label, sub;
  final Color color;
  final VoidCallback? onTap;
  const _Btn({required this.emoji, required this.label, required this.sub, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)],
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color, letterSpacing: 1)),
          Text(sub,   style: const TextStyle(fontSize: 13, color: Color(0xFF9090AA))),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
      ]),
    ),
  );
}
