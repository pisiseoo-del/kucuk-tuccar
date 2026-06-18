import 'package:flutter/material.dart';
import '../painters/logo_painter.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)));
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0A0A14),
    body: Center(child: FadeTransition(opacity: _fade, child: Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(animation: _ctrl, builder: (_, __) => CustomPaint(size: const Size(180, 180), painter: LogoPainter(animValue: _ctrl.value))),
      const SizedBox(height: 24),
      const Text('Küçük Tüccar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFF0F0FF), letterSpacing: -0.5)),
      const SizedBox(height: 6),
      const Text('Çiftlikten Hale', style: TextStyle(fontSize: 16, color: Color(0xFF39FF14), letterSpacing: 2, fontWeight: FontWeight.w600)),
    ]))),
  );
}
