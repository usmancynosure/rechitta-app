import 'package:flutter/material.dart';
import '../data/project_data.dart';
import '../theme/app_theme.dart';
import '../widgets/asset_image_or.dart';
import '../widgets/glowing_orb.dart';
import '../widgets/voice_control_bar.dart';

/// The "Built to answer, not just present" experience — a swipeable project
/// deck (overview, residences, payment plans, floor plan) with a persistent
/// voice-briefing control bar. Swiping advances the "spoken" section.
class ProjectOverviewScreen extends StatefulWidget {
  const ProjectOverviewScreen({super.key});

  @override
  State<ProjectOverviewScreen> createState() => _ProjectOverviewScreenState();
}

class _ProjectOverviewScreenState extends State<ProjectOverviewScreen> {
  final PageController _pages = PageController();
  int _index = 0;
  bool _speaking = true;
  bool _muted = false;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    _pages.animateToPage(
      i,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = ProjectData.slides;
    final slide = slides[_index];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Swipeable slides.
          PageView.builder(
            controller: _pages,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() {
              _index = i;
              _speaking = true; // "speak" each new section
            }),
            itemBuilder: (context, i) => _SlideView(slide: slides[i]),
          ),

          // Top gradient + header.
          _Header(
            projectName: ProjectData.name,
            onBack: () => Navigator.of(context).maybePop(),
          ),

          // Page dots.
          Positioned(
            top: MediaQuery.of(context).padding.top + 64,
            right: 20,
            child: _PageDots(count: slides.length, index: _index),
          ),

          // Voice control bar pinned to the bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 18,
                top: 10,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xF2000000)],
                ),
              ),
              child: VoiceControlBar(
                speaking: _speaking,
                muted: _muted,
                caption: slide.caption,
                onPlayPause: () => setState(() => _speaking = !_speaking),
                onOrbTap: () => setState(() => _speaking = !_speaking),
                onMuteToggle: () => setState(() => _muted = !_muted),
              ),
            ),
          ),

          // Prev / next affordances.
          if (_index < slides.length - 1)
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: IconButton(
                  onPressed: () => _goTo(_index + 1),
                  icon: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 30),
                ),
              ),
            ),
          if (_index > 0)
            Positioned(
              left: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: IconButton(
                  onPressed: () => _goTo(_index - 1),
                  icon: const Icon(Icons.chevron_left_rounded,
                      color: AppColors.textMuted, size: 30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final ProjectSlide slide;

  @override
  Widget build(BuildContext context) {
    // Floor-plan slides use a light plan block; others use a full-bleed image.
    if (slide.floorPlanImage != null) {
      return _FloorPlanSlide(slide: slide);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AssetImageOr(
          asset: slide.backgroundImage,
          fit: BoxFit.cover,
          fallback: const ColoredBox(color: Color(0xFF10131A)),
        ),
        // Legibility scrim.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xB3000000), Color(0x33000000), Color(0xF2000000)],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  slide.section,
                  style: AppTheme.body(
                    size: 11,
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(slide.title, style: AppTheme.display(size: 34)),
                const SizedBox(height: 16),
                if (slide.overviewText != null)
                  Text(
                    slide.overviewText!,
                    style: AppTheme.body(
                      size: 14.5,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                if (slide.bullets != null) ...[
                  for (final b in slide.bullets!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: _Dot(),
                          ),
                          Expanded(
                            child: Text(
                              b,
                              style: AppTheme.body(
                                size: 14.5,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FloorPlanSlide extends StatelessWidget {
  const _FloorPlanSlide({required this.slide});
  final ProjectSlide slide;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 110, 24, 210),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(slide.title, style: AppTheme.display(size: 30)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBE6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: AssetImageOr(
                  asset: slide.floorPlanImage,
                  fit: BoxFit.contain,
                  fallback: const Center(
                    child: Icon(Icons.grid_on_rounded,
                        size: 48, color: Color(0xFFB9B4A8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (slide.specs != null)
              Wrap(
                spacing: 20,
                runSpacing: 12,
                children: [
                  for (final s in slide.specs!)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(s.icon, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          s.value,
                          style: AppTheme.body(
                            size: 13,
                            weight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.projectName, required this.onBack});
  final String projectName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 6,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textPrimary, size: 28),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GlowingOrb(size: 18, showMark: false),
                const SizedBox(width: 8),
                Text(
                  projectName,
                  style: AppTheme.body(
                    size: 11,
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(vertical: 3),
            width: 6,
            height: i == index ? 20 : 6,
            decoration: BoxDecoration(
              color: i == index
                  ? AppColors.blueBright
                  : AppColors.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.blueBright,
        shape: BoxShape.circle,
      ),
    );
  }
}
