import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';

class BackgroundPainter extends CustomPainter {
  final ProduceItem produce;
  final double animValue;
  const BackgroundPainter({required this.produce, required this.animValue});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..shader = LinearGradient(colors: produce.bgGradient, begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(Offset.zero & size));
    canvas.drawRect(Offset.zero & size, Paint()..shader = RadialGradient(colors: [Colors.transparent, const Color(0x73000000)], radius: 0.9).createShader(Offset.zero & size));
  }
  @override bool shouldRepaint(BackgroundPainter o) => o.produce.id != produce.id || o.animValue != animValue;
}

class ParticleLayer extends StatelessWidget {
  final ProduceItem produce;
  final double animValue;
  const ParticleLayer({super.key, required this.produce, required this.animValue});
  @override
  Widget build(BuildContext context) {
    final rng = Random(produce.id.hashCode);
    final size = MediaQuery.of(context).size;
    return IgnorePointer(child: Stack(children: List.generate(8, (i) {
      final sx = rng.nextDouble(); final speed = 0.3 + rng.nextDouble() * 0.4; final phase = rng.nextDouble();
      final y = 1.0 - ((animValue * speed + phase) % 1.0);
      final x = sx + sin(animValue * 2 * pi + i) * 0.04;
      return Positioned(
        left: (x * size.width).clamp(0, size.width - 30),
        top:  (y * size.height).clamp(0, size.height - 30),
        child: Opacity(opacity: (y * 2).clamp(0, 1) * 0.6,
          child: Text(produce.particleEmoji, style: TextStyle(fontSize: 14 + rng.nextDouble() * 8))),
      );
    })));
  }
}
