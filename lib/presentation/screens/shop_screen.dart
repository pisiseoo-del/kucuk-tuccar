import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/game_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_state.dart';
import '../../game/game_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final game  = context.watch<GameProvider>();
    final state = game.state;
    final items = [
      (ShopItemId.steelScissors,   '✂️', 'Çelik Bağ Makası',      'Hitbox\'ı büyütür',            GameConstants.steelScissorsPrice),
      (ShopItemId.rotMedicine,     '💊', 'Çürük Savar İlaç',       'Çürük meyve oranını azaltır',  GameConstants.rotMedicinePrice),
      (ShopItemId.modifiedTractor, '🚛', 'Modifiyeli Traktör',     'Kamyon hızını yavaşlatır',     GameConstants.modifiedTractorPrice),
      (ShopItemId.goldenBasket,    '🧺', 'Altın Parıltılı Sepet',  'Bonus kazancı artırır',        GameConstants.goldenBasketPrice),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(title: const Text('🛒  KÖYPARAZI'), leading: const BackButton(color: Color(0xFF9090AA))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: AppTheme.glassCard(borderColor: const Color(0x66FFD700)),
          child: Row(children: [
            const Text('💰', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text('Bütçe: ₺${state.moneyDisplay}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFFFD700))),
          ]),
        ),
        const SizedBox(height: 20),
        ...items.map((item) {
          final (id, emoji, name, desc, price) = item;
          final owned     = state.shopItems.any((s) => s.id == id && s.owned);
          final canAfford = state.moneyKurus >= price * 100;
          return _Tile(emoji: emoji, name: name, desc: desc, price: price, owned: owned, canAfford: canAfford,
            onBuy: () {
              if (!game.buyItem(id) && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yeterli para yok!'), backgroundColor: Color(0xFFF44336)));
              }
            });
        }),
      ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final String emoji, name, desc; final int price; final bool owned, canAfford; final VoidCallback onBuy;
  const _Tile({required this.emoji, required this.name, required this.desc, required this.price, required this.owned, required this.canAfford, required this.onBuy});
  @override
  Widget build(BuildContext context) {
    final color = owned ? const Color(0xFF9090AA) : canAfford ? const Color(0xFFFFD700) : const Color(0xFFF44336);
    return Container(
      margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard(borderColor: color.withValues(alpha: 0.3)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFFF0F0FF))),
          Text(desc, style: const TextStyle(color: Color(0xFF9090AA), fontSize: 13)),
          const SizedBox(height: 4),
          Text('₺$price', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
        ])),
        const SizedBox(width: 12),
        if (owned) const Text('✅', style: TextStyle(fontSize: 24))
        else GestureDetector(onTap: canAfford ? onBuy : null, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: AppTheme.neonButton(canAfford ? const Color(0xFFFFD700) : const Color(0xFF2A2A3D)),
          child: Text('AL', style: TextStyle(fontWeight: FontWeight.w900, color: canAfford ? const Color(0xFF0A0A14) : const Color(0xFF9090AA), fontSize: 13)),
        )),
      ]),
    );
  }
}
