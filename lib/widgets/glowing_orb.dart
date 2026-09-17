import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'rechitta_logo.dart';

/// The signature Rechitta orb — a glowing blue sphere that gently "breathes",
/// with the white R mark floating at its core. Optionally shows the mark.
class GlowingOrb extends StatefulWidget {
  const GlowingOrb({
    super.key,
    this.size = 64,
    this.showMark = true,
    this.active = true,
  });

  final double size;
  final bool showMark;

  /// When false the orb dims slightly (e.g. paused / idle state).
  final bool active;

  @override
  State<GlowingOrb> createState() => _GlowingOrbState();
}

class _GlowingOrbState extends State<GlowingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Breathing 0..1 eased.
        final t = Curves.easeInOut.transform(_controller.value);
        final pulse = widget.active ? (0.92 + t * 0.12) : 0.8;
        final glowSpread = widget.active ? (0.9 + t * 0.35) : 0.6;
        return SizedBox(
          width: s * 1.9,
          height: s * 1.9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer soft glow halo.
              Container(
                width: s * 1.9 * glowSpread,
                height: s * 1.9 * glowSpread,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.blueBright.withValues(alpha: 0.45 * pulse),
                      AppColors.blueGlow.withValues(alpha: 0.20 * pulse),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              // The sphere body.
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: s,
                  height: s,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      radius: 1.1,
                      colors: [
                        Color(0xFF5AA0FF),
                        AppColors.blue,
                        AppColors.blueDeep,
                        Color(0xFF041A4D),
                      ],
                      stops: [0.0, 0.4, 0.8, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.55 * pulse),
                        blurRadius: s * 0.7,
                        spreadRadius: s * 0.05,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _SpecularHighlight(size: s),
                  ),
                ),
              ),
              if (widget.showMark)
                RechittaMark(size: s * 0.42, color: Colors.white),
            ],
          ),
        );
      },
    );
  }
}

/// A faint diagonal specular sheen to give the sphere volume.
class _SpecularHighlight extends StatelessWidget {
  const _SpecularHighlight({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 5,
      child: Container(
        width: size * 0.7,
        height: size * 0.34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
