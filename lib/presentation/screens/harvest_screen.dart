import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/audio_manager.dart';
import '../../game/game_provider.dart';
import '../../game/harvest/harvest_controller.dart';
import '../painters/background_painter.dart';
import '../../data/models/game_state.dart';

class HarvestScreen extends StatefulWidget {
  final ProduceItem produce;
  const HarvestScreen({super.key, required this.produce});
  @override State<HarvestScreen> createState() => _HarvestScreenState();
}
class _HarvestScreenState extends State<HarvestScreen> with SingleTickerProviderStateMixin {
  late HarvestController _harvest;
  late AnimationController _bgCtrl;
  Timer? _ticker;
  DateTime? _lastTick;
  bool _resultShown = false;

  @override
  void initState() {
    super.initState();
    _harvest = HarvestController(produce: widget.produce, gameState: context.read<GameProvider>().state);
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _lastTick = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final now = DateTime.now();
      final dt = now.difference(_lastTick!).inMilliseconds / 1000.0;
      _lastTick = now;
      _harvest.tick(dt, MediaQuery.of(context).size.width);
      if (_harvest.finished && !_resultShown) _showResult();
    });
  }

  @override void dispose() { _ticker?.cancel(); _bgCtrl.dispose(); _harvest.dispose(); super.dispose(); }

  void _showResult() {
    _resultShown = true; _ticker?.cancel();
    final r = _harvest.result;
    context.read<GameProvider>().applyHarvestResult(r);
    showModalBottomSheet(
      context: context, isDismissible: false, backgroundColor: Colors.transparent,
      builder: (_) => _ResultSheet(result: r, produce: widget.produce, onContinue: () { Navigator.pop(context); Navigator.pop(context); }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTapDown: (d) {
          final prev = _harvest.normalCaught + _harvest.goldenCaught;
          _harvest.onTap(d.localPosition.dx, size.width);
          if (_harvest.normalCaught + _harvest.goldenCaught > prev) AudioManager.instance.playCatch();
        },
        child: Stack(children: [
          AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => CustomPaint(size: size, painter: BackgroundPainter(produce: widget.produce, animValue: _bgCtrl.value))),
          AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => ParticleLayer(produce: widget.produce, animValue: _bgCtrl.value)),
          SafeArea(child: Column(children: [
            _HUD(harvest: _harvest, produce: widget.produce),
            Expanded(child: ListenableBuilder(listenable: _harvest, builder: (_, __) => Stack(children: [
              Positioned(bottom: 20, left: _harvest.catcherX * size.width - _harvest.catcherWidth / 2,
                child: _Catcher(produce: widget.produce, width: _harvest.catcherWidth)),
              ..._harvest.objects.map((o) => Positioned(
                left: o.x * size.width - 20,
                top:  o.y * (size.height - 200) + 60,
                child: Text(o.emoji, style: TextStyle(fontSize: o.isGolden ? 36 : 28,
                    shadows: o.isGolden ? const [Shadow(color: Color(0xFFFFD700), blurRadius: 12)] : null)),
              )),
            ]))),
          ])),
        ]),
      ),
    );
  }
}

class _HUD extends StatelessWidget {
  final HarvestController harvest;
  final ProduceItem produce;
  const _HUD({required this.harvest, required this.produce});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: harvest, builder: (_, __) =>
    Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: AppTheme.glassCard(),
      child: Row(children: [
        Text(produce.emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 8),
        Expanded(child: Text(produce.nameTr, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF0F0FF)))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: harvest.secondsLeft < 10 ? const Color(0x4DF44336) : const Color(0x2639FF14),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: harvest.secondsLeft < 10 ? const Color(0xFFF44336) : const Color(0xFF39FF14)),
          ),
          child: Text('${harvest.secondsLeft.toInt()}s', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: harvest.secondsLeft < 10 ? const Color(0xFFF44336) : const Color(0xFF39FF14))),
        ),
        const SizedBox(width: 12),
        Text('${harvest.normalCaught + harvest.goldenCaught}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFF0F0FF))),
        const Text(' kg', style: TextStyle(color: Color(0xFF9090AA))),
      ]),
    ),
  );
}

class _Catcher extends StatelessWidget {
  final ProduceItem produce;
  final double width;
  const _Catcher({required this.produce, required this.width});
  @override
  Widget build(BuildContext context) => Container(
    width: width, height: 44,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [produce.bgGradient.first.withValues(alpha: 0.9), produce.bgGradient.last.withValues(alpha: 0.9)]),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF39FF14), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x8039FF14), blurRadius: 12)],
    ),
    child: Center(child: Text(
      produce.harvestType == HarvestType.bladeCut ? '✂️' : produce.harvestType == HarvestType.truckLoad ? '🚛' : '🧺',
      style: const TextStyle(fontSize: 22),
    )),
  );
}

class _ResultSheet extends StatelessWidget {
  final HarvestResult result;
  final ProduceItem produce;
  final VoidCallback onContinue;
  const _ResultSheet({required this.result, required this.produce, required this.onContinue});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: const BoxDecoration(color: Color(0xFF14141F), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('✅ Hasat Tamamlandı!', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF39FF14))),
      const SizedBox(height: 20),
      _Row(label: '${produce.emoji} Normal', value: '${result.normalCount} kg'),
      _Row(label: '⭐ Altın', value: '${result.goldenCount * GameConstants.goldenMultiplier} kg'),
      _Row(label: '💨 Kaçan', value: '${result.missedCount}'),
      const Divider(color: Color(0xFF2A2A3D), height: 24),
      _Row(label: 'TOPLAM', value: '${result.totalKg} kg', bold: true),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onContinue, child: const Text("HAL'A GİT →"))),
    ]),
  );
}
class _Row extends StatelessWidget {
  final String label, value; final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) {
    final s = bold ? const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFFF0F0FF)) : const TextStyle(color: Color(0xFF9090AA));
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: s), Text(value, style: s.copyWith(color: const Color(0xFF39FF14))),
    ]));
  }
}
