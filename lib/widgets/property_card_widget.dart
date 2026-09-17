import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// A property showcase card — hero render, title, blurb and headline stats.
/// Mirrors the "Architectural Mastery" card from the product mockups.
class PropertyCardWidget extends StatelessWidget {
  const PropertyCardWidget({super.key, required this.data});

  final PropertyCard data;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1D26), Color(0xFF232438)],
        ),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero render placeholder (stand-in for the building photo).
          AspectRatio(
            aspectRatio: 16 / 10,
            child: _RenderPlaceholder(colors: data.gradient),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTheme.body(
                    size: 17,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.description,
                  style: AppTheme.body(
                    size: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (final stat in data.stats) ...[
                      Expanded(child: _Stat(stat: stat)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.stat});
  final PropertyStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.value,
          style: AppTheme.body(
            size: 16,
            weight: FontWeight.w600,
            color: AppColors.blueBright,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          style: AppTheme.body(size: 11.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// A soft architectural gradient with faint window-grid lines, standing in for
/// a real render so the demo needs no bundled image assets.
class _RenderPlaceholder extends StatelessWidget {
  const _RenderPlaceholder({required this.colors});
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: CustomPaint(painter: _FacadePainter(), size: Size.infinite),
    );
  }
}

class _FacadePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    // Vertical mullions.
    for (double x = size.width * 0.18; x < size.width; x += size.width * 0.14) {
      canvas.drawLine(Offset(x, size.height * 0.15),
          Offset(x, size.height * 0.95), paint);
    }
    // Horizontal floor slabs.
    for (double y = size.height * 0.28; y < size.height; y += size.height * 0.16) {
      canvas.drawLine(Offset(size.width * 0.1, y),
          Offset(size.width * 0.92, y), paint);
    }
    // A soft sky glow at top.
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.10), Colors.transparent],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.75, size.height * 0.15),
          radius: size.width * 0.5));
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
