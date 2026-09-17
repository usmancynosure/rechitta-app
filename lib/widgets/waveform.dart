import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A live audio-style waveform. Animates while [active]; collapses to a flat
/// idle line otherwise. Purely decorative — stands in for TTS playback.
class Waveform extends StatefulWidget {
  const Waveform({
    super.key,
    this.active = true,
    this.barCount = 28,
    this.color = AppColors.blueBright,
    this.height = 28,
  });

  final bool active;
  final int barCount;
  final Color color;
  final double height;

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return CustomPaint(
            painter: _WavePainter(
              phase: _c.value,
              barCount: widget.barCount,
              color: widget.color,
              active: widget.active,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.phase,
    required this.barCount,
    required this.color,
    required this.active,
  });

  final double phase;
  final int barCount;
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final gap = size.width / barCount;
    final barW = gap * 0.5;
    final midY = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = barW
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < barCount; i++) {
      final x = gap * i + gap / 2;
      double amp;
      if (active) {
        // Layer two sine waves so the motion looks organic.
        final a = math.sin((i * 0.6) + phase * 2 * math.pi);
        final b = math.sin((i * 0.27) - phase * 3 * math.pi);
        amp = (0.35 + 0.65 * ((a + b) / 2).abs());
      } else {
        amp = 0.12;
      }
      final h = amp * size.height;
      paint.color = color.withValues(alpha: active ? 0.55 + 0.45 * amp : 0.35);
      canvas.drawLine(Offset(x, midY - h / 2), Offset(x, midY + h / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.active != active;
}
