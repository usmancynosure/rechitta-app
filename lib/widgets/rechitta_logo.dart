import 'package:flutter/material.dart';

/// The Rechitta "R" mark — a bold, forward-leaning glyph built from two
/// pennant-like strokes, approximating the brand logo.
class RechittaMark extends StatelessWidget {
  const RechittaMark({super.key, this.size = 24, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RechittaMarkPainter(color),
    );
  }
}

class _RechittaMarkPainter extends CustomPainter {
  _RechittaMarkPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    double x(double v) => v / 100 * w;
    double y(double v) => v / 100 * h;

    // Left vertical stem.
    final stem = Path()
      ..moveTo(x(14), y(8))
      ..lineTo(x(36), y(8))
      ..lineTo(x(36), y(92))
      ..lineTo(x(14), y(92))
      ..close();

    // Upper "flag" — the bowl of the R, leaning forward.
    final topFlag = Path()
      ..moveTo(x(36), y(8))
      ..lineTo(x(86), y(8))
      ..lineTo(x(58), y(48))
      ..lineTo(x(36), y(48))
      ..close();

    // Lower "flag" — the leg of the R, mirrored forward.
    final legFlag = Path()
      ..moveTo(x(36), y(52))
      ..lineTo(x(64), y(52))
      ..lineTo(x(90), y(92))
      ..lineTo(x(58), y(92))
      ..close();

    canvas.drawPath(stem, paint);
    canvas.drawPath(topFlag, paint);
    canvas.drawPath(legFlag, paint);
  }

  @override
  bool shouldRepaint(covariant _RechittaMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Wordmark: the mark followed by "Rechitta" — used in headers/splash.
class RechittaWordmark extends StatelessWidget {
  const RechittaWordmark({super.key, this.fontSize = 22, this.color = Colors.white});

  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RechittaMark(size: fontSize * 0.95, color: color),
        SizedBox(width: fontSize * 0.35),
        Text(
          'Rechitta',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
