import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_state.dart';
import '../../game/game_provider.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final inStorage = game.state.storage.where((s) => s.amountKg > 0).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(title: const Text('🏪  HAL — YEREL BORSA'), leading: const BackButton(color: Color(0xFF9090AA))),
      body: inStorage.isEmpty
          ? const Center(child: Text('Depoda ürün yok.\nÖnce hasat et!', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9090AA), fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: inStorage.length,
              itemBuilder: (_, i) => _Tile(entry: inStorage[i], game: game),
            ),
    );
  }
}

class _Tile extends StatelessWidget {
  final StorageEntry entry;
  final GameProvider game;
  const _Tile({required this.entry, required this.game});
  @override
  Widget build(BuildContext context) {
    final state   = game.state;
    final produce = GameConstants.allProduce.firstWhere((p) => p.id == entry.produceId, orElse: () => GameConstants.allProduce.first);
    final md      = state.marketDataFor(entry.produceId);
    final ppkg    = state.effectivePrice(entry.produceId);
    final total   = entry.amountKg * ppkg;
    final (emoji, label, color) = switch (md.trend) {
      PriceTrend.high => ('😄', 'Fiyat Yüksek!', AppTheme.priceHigh),
      PriceTrend.low  => ('😢', 'Fiyat Düşük!',  AppTheme.priceLow),
      _               => ('😐', 'Normal Fiyat',   AppTheme.priceNorm),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard(borderColor: color.withValues(alpha: 0.3)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(produce.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(produce.nameTr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFFF0F0FF))),
            Text('Depoda: ${entry.amountKg} kg', style: const TextStyle(color: Color(0xFF9090AA), fontSize: 13)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ]),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('₺${(ppkg / 100).toStringAsFixed(2)}/kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text('Toplam: ₺${(total / 100).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF9090AA))),
          ])),
          if (md.trend != PriceTrend.low)
            _ActBtn(label: 'SAT', color: AppTheme.priceHigh, onTap: () async {
              final earned = await game.sellProduce(entry.produceId, entry.amountKg);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('✅ ₺${(earned / 100).toStringAsFixed(0)} kazandın!'),
                backgroundColor: AppTheme.priceHigh, duration: const Duration(seconds: 2),
              ));
            })
          else
            _ActBtn(label: 'DEPOLA', color: AppTheme.priceLow, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fiyat düşük — depoluyorsun.'), backgroundColor: Color(0xFF2A2A3D)));
            }),
        ]),
      ]),
    );
  }
}

class _ActBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _ActBtn({required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: AppTheme.neonButton(color),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0A0A14), fontSize: 14, letterSpacing: 1)),
    ),
  );
}
