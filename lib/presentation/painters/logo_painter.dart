import 'dart:math';
import 'package:flutter/material.dart';

class LogoPainter extends CustomPainter {
  final double animValue;
  const LogoPainter({this.animValue = 0});
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2; final cy = size.height / 2; final r = size.width * 0.42;
    canvas.drawCircle(Offset(cx, cy), r + 12, Paint()..color = const Color(0x3339FF14)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22));
    canvas.drawCircle(Offset(cx, cy), r, Paint()..shader = RadialGradient(colors: [const Color(0xFF1A2A1A), const Color(0xFF0A0A14)]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)));
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFF39FF14)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    final wm = Path()..moveTo(cx - r*.65, cy + r*.1)..quadraticBezierTo(cx, cy + r*.72, cx + r*.65, cy + r*.1)..close();
    canvas.drawPath(wm, Paint()..color = const Color(0xFF1B7A3A));
    final fl = Path()..moveTo(cx - r*.52, cy + r*.12)..quadraticBezierTo(cx, cy + r*.58, cx + r*.52, cy + r*.12)..close();
    canvas.drawPath(fl, Paint()..color = const Color(0xFFE63946));
    final sp = Paint()..color = const Color(0xFF0A0A14);
    for (int i = -1; i <= 1; i++) canvas.drawOval(Rect.fromCenter(center: Offset(cx + i * r*.18, cy + r*.28), width: 5, height: 8), sp);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - r*.28), width: r*.36, height: r*.46),
        Paint()..shader = LinearGradient(colors: [const Color(0xFFD4813A), const Color(0xFF8B4513)]).createShader(Rect.fromCenter(center: Offset(cx, cy - r*.28), width: r*.36, height: r*.46)));
    final cap = Path()..moveTo(cx - r*.1, cy - r*.5)..quadraticBezierTo(cx, cy - r*.63, cx + r*.1, cy - r*.5)..close();
    canvas.drawPath(cap, Paint()..color = const Color(0xFF5C3A1E));
    if (animValue > 0) {
      final pp = Paint()..color = Colors.white.withValues(alpha: animValue*.9)..strokeWidth=1.5..strokeCap=StrokeCap.round..style=PaintingStyle.stroke;
      for (int i = 0; i < 4; i++) {
        final a = i * pi / 2; final l = 7.0 * animValue;
        canvas.drawLine(Offset(cx+r*.25, cy-r*.55), Offset(cx+r*.25+cos(a)*l, cy-r*.55+sin(a)*l), pp);
      }
    }
  }
  @override bool shouldRepaint(LogoPainter o) => o.animValue != animValue;
}
