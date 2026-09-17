import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The bottom input bar: a mic affordance, a text field and a send button.
class MessageInputBar extends StatelessWidget {
  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMic,
    this.listening = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback onMic;
  final bool listening;

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    onSend(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _CircleButton(
                icon: listening ? Icons.stop_rounded : Icons.mic_none_rounded,
                onTap: onMic,
                highlighted: listening,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _submit(),
                  textInputAction: TextInputAction.send,
                  style: AppTheme.body(size: 14.5, color: AppColors.textPrimary),
                  cursorColor: AppColors.blueBright,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Type your message here…',
                    hintStyle:
                        AppTheme.body(size: 14.5, color: AppColors.textMuted),
                  ),
                ),
              ),
              _CircleButton(
                icon: Icons.arrow_upward_rounded,
                onTap: _submit,
                filled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.highlighted = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final Color bg = filled
        ? AppColors.blue
        : (highlighted ? AppColors.blue.withValues(alpha: 0.2) : Colors.transparent);
    final Color fg = filled ? Colors.white : AppColors.textSecondary;
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: fg),
        ),
      ),
    );
  }
}
