import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'asset_image_or.dart';

/// A floor-plan card — plan image with a specification grid beneath, mirroring
/// the "Floor Plan / 2 Bedroom" mockup.
class FloorPlanCardWidget extends StatelessWidget {
  const FloorPlanCardWidget({super.key, required this.data});

  final FloorPlanCard data;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.card,
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan image on a light mat so the dark-on-light plan reads clearly.
          Container(
            color: const Color(0xFFEDEBE6),
            child: AspectRatio(
              aspectRatio: 1,
              child: AssetImageOr(
                asset: data.imageAsset,
                fit: BoxFit.contain,
                fallback: const _PlanFallback(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTheme.body(
                    size: 16,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 4.5,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  children: [for (final s in data.specs) _Spec(spec: s)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.spec});
  final FloorPlanSpec spec;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(spec.icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              spec.value,
              style: AppTheme.body(
                size: 13.5,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              spec.label,
              style: AppTheme.body(size: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

/// Simple placeholder shown if the plan image hasn't been generated yet.
class _PlanFallback extends StatelessWidget {
  const _PlanFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.grid_on_rounded, size: 48, color: Color(0xFFB9B4A8)),
    );
  }
}
