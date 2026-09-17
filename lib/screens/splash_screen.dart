import 'package:flutter/material.dart';
import '../theme/app_images.dart';
import '../theme/app_theme.dart';
import '../widgets/asset_image_or.dart';
import '../widgets/glowing_orb.dart';
import '../widgets/rechitta_logo.dart';
import 'voice_briefing_screen.dart';

/// The hero / landing screen — "One Source of Truth" — over the glowing orb
/// backdrop. Falls back to the live-painted orb if the image isn't present.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _enter(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, anim, secondary) => const VoiceBriefingScreen(),
        transitionsBuilder: (context, anim, secondary, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Orb backdrop (image) with a live-orb fallback.
          AssetImageOr(
            asset: AppImages.orbBackdropPortrait,
            fit: BoxFit.cover,
            fallback: const ColoredBox(
              color: AppColors.background,
              child: Center(child: GlowingOrb(size: 120)),
            ),
          ),
          // Bottom scrim so text stays legible over the image.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE6000000)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const RechittaWordmark(fontSize: 22),
                  const Spacer(),
                  // Headline.
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'One Source of\n',
                          style: AppTheme.display(size: 40, height: 1.05),
                        ),
                        TextSpan(
                          text: 'Truth',
                          style: AppTheme.display(
                            size: 40,
                            color: AppColors.blueBright,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Every unit, every price, every answer — always '
                    'current, in whatever language your buyer speaks.',
                    textAlign: TextAlign.center,
                    style: AppTheme.body(
                      size: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _EnterButton(label: "I'm a Broker", onTap: () => _enter(context)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _enter(context),
                    child: Text(
                      "I'm a Developer",
                      style: AppTheme.body(size: 14, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnterButton extends StatelessWidget {
  const _EnterButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: AppTheme.body(size: 15, weight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}
