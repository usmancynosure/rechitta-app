import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Analytics card — projected yield, confidence, a gold trend line and
/// community/safety scores. Mirrors the "Projected Market Yield" mockup.
class RoiCardWidget extends StatelessWidget {
  const RoiCardWidget({super.key, required this.data});

  final RoiCard data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF191A24), Color(0xFF241B33)],
        ),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Metric(
                  label: 'Projected Market Yield (ROI)',
                  value: data.yieldPercent,
                ),
              ),
              _Metric(
                label: 'Confidence',
                value: data.confidence,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 92,
            child: CustomPaint(
              painter: _TrendPainter(data.trend),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.baselineLabel,
                  style: AppTheme.body(size: 10.5, color: AppColors.textMuted)),
              Text(data.peakLabel,
                  style: AppTheme.body(size: 10.5, color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Yield calculation incorporates historical volatility and current '
            'market liquidity trends.',
            style: AppTheme.body(size: 11, color: AppColors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Community Score',
                  value: data.communityScore,
                  accent: AppColors.green,
                ),
              ),
              _Metric(label: 'GRADE', value: data.grade, alignEnd: true, accent: AppColors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Public Safety Index',
                  style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
              Text(data.safetyIndex,
                  style: AppTheme.body(
                      size: 13, weight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.accent,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.body(size: 11, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.display(
            size: 26,
            weight: FontWeight.w700,
            color: accent ?? AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

/// Draws the gold ROI line with a soft fill, node dots and a dashed baseline.
class _TrendPainter extends CustomPainter {
  _TrendPainter(this.points);
  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final dx = size.width / (points.length - 1);
    Offset pt(int i) => Offset(dx * i, size.height * (1 - points[i]));

    // Dashed baseline.
    final baseY = size.height * 0.78;
    final dashPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, baseY), Offset(x + 4, baseY), dashPaint);
    }

    // Fill under the line.
    final fill = Path()..moveTo(0, size.height);
    for (int i = 0; i < points.length; i++) {
      fill.lineTo(pt(i).dx, pt(i).dy);
    }
    fill.lineTo(size.width, size.height);
    fill.close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gold.withValues(alpha: 0.22), Colors.transparent],
        ).createShader(Offset.zero & size),
    );

    // The line itself.
    final line = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < points.length; i++) {
      line.lineTo(pt(i).dx, pt(i).dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Node dots on a few peaks.
    final dot = Paint()..color = AppColors.gold;
    final dotRing = Paint()
      ..color = const Color(0xFF241B33)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final i in [2, 5, points.length - 1]) {
      canvas.drawCircle(pt(i), 3.5, dot);
      canvas.drawCircle(pt(i), 3.5, dotRing);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points;
}
