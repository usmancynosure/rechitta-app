import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/glowing_orb.dart';
import '../widgets/language_picker.dart';
import '../widgets/message_input_bar.dart';
import '../widgets/suggestion_chips.dart';

/// The signature Rechitta screen: a voice-driven AI briefing you can read,
/// interrupt and question — with property and analytics cards inline.
class VoiceBriefingScreen extends StatefulWidget {
  const VoiceBriefingScreen({super.key});

  @override
  State<VoiceBriefingScreen> createState() => _VoiceBriefingScreenState();
}

class _VoiceBriefingScreenState extends State<VoiceBriefingScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  String _language = 'English';
  bool _thinking = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    // Seed the conversation with the opening briefing exchange.
    _messages.addAll(MockData.conversation.take(2));
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text) async {
    setState(() {
      _messages.add(ChatMessage(sender: Sender.user, text: text));
      _thinking = true;
    });
    _scrollToBottom();

    // Simulate the AI "thinking" before it answers.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _thinking = false;
      _messages.add(MockData.replyFor(text));
    });
    _scrollToBottom();
  }

  void _toggleMic() {
    setState(() => _listening = !_listening);
    // A real build would start speech-to-text here.
  }

  Future<void> _pickLanguage() async {
    final picked = await LanguagePicker.show(context, _language);
    if (picked != null && mounted) {
      setState(() => _language = picked);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.surfaceElevated,
            content: Text('Rechitta will now speak in $picked',
                style: AppTheme.body(size: 13)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(
            projectName: MockData.projectName,
            language: _language,
            onBack: () {},
            onLanguage: _pickLanguage,
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              children: [
                for (final m in _messages) ChatBubble(message: m),
                if (_thinking) const _TypingIndicator(),
              ],
            ),
          ),
          SuggestionChips(
            suggestions: MockData.suggestions,
            onTap: (s) => _send(s.label),
          ),
          const SizedBox(height: 10),
          MessageInputBar(
            controller: _input,
            onSend: _send,
            onMic: _toggleMic,
            listening: _listening,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.projectName,
    required this.language,
    required this.onBack,
    required this.onLanguage,
  });

  final String projectName;
  final String language;
  final VoidCallback onBack;
  final VoidCallback onLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 92,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered orb.
            const GlowingOrb(size: 42),
            Positioned(
              left: 8,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textSecondary, size: 28),
              ),
            ),
            Positioned(
              right: 6,
              child: TextButton.icon(
                onPressed: onLanguage,
                icon: const Icon(Icons.language_rounded,
                    color: AppColors.textSecondary, size: 20),
                label: Text(
                  language,
                  style: AppTheme.body(size: 13, color: AppColors.textSecondary),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Text(
                projectName,
                style: AppTheme.body(
                  size: 10.5,
                  color: AppColors.textMuted,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three-dot "AI is composing" indicator with the small orb.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const GlowingOrb(size: 22, showMark: false),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return Row(
                children: List.generate(3, (i) {
                  final t = (_c.value + i * 0.2) % 1.0;
                  final o = 0.3 + (0.7 * (1 - (t - 0.5).abs() * 2)).clamp(0, 1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textSecondary.withValues(alpha: o.toDouble()),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
