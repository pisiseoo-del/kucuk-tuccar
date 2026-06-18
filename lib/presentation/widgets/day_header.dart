import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../game/game_provider.dart';

class DayHeader extends StatelessWidget {
  final VoidCallback? onSettings;
  const DayHeader({super.key, this.onSettings});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameProvider>().state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('GÜN ${state.day}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF39FF14), letterSpacing: 2)),
          Text('₺${state.moneyDisplay}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFF0F0FF))),
        ]),
        const Spacer(),
        IconButton(icon: const Icon(Icons.settings_outlined, color: Color(0xFF9090AA)), onPressed: onSettings),
      ]),
    );
  }
}
