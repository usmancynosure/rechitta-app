import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glowing_orb.dart';
import 'waveform.dart';

/// The floating voice-briefing control bar from the mockups:
/// [play/pause] · [glowing orb] · [mic mute]. A caption line and a live
/// waveform sit above it while the briefing is "speaking".
class VoiceControlBar extends StatelessWidget {
  const VoiceControlBar({
    super.key,
    required this.speaking,
    required this.muted,
    required this.caption,
    required this.onPlayPause,
    required this.onOrbTap,
    required this.onMuteToggle,
  });

  final bool speaking;
  final bool muted;
  final String caption;
  final VoidCallback onPlayPause;
  final VoidCallback onOrbTap;
  final VoidCallback onMuteToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Caption + waveform.
        AnimatedOpacity(
          opacity: speaking ? 1 : 0.55,
          duration: const Duration(milliseconds: 250),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.body(
                    size: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 180,
                child: Waveform(active: speaking && !muted, height: 26),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // The control pill.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xCC0B0C10),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.borderSoft),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PillButton(
                icon: speaking ? Icons.pause_rounded : Icons.play_arrow_rounded,
                onTap: onPlayPause,
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onOrbTap,
                behavior: HitTestBehavior.opaque,
                child: GlowingOrb(size: 44, active: speaking && !muted),
              ),
              const SizedBox(width: 6),
              _PillButton(
                icon: muted ? Icons.mic_off_rounded : Icons.mic_none_rounded,
                onTap: onMuteToggle,
                highlighted: muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted
          ? AppColors.blue.withValues(alpha: 0.22)
          : Colors.white.withValues(alpha: 0.06),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon,
              size: 22,
              color: highlighted ? AppColors.blueBright : AppColors.textPrimary),
        ),
      ),
    );
  }
}
