import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const List<String> kLanguages = [
  'Español',
  'العربية',
  'हिन्दी',
  'ਪੰਜਾਬੀ',
  'Русский',
  'English',
  'Français',
  'Türkçe',
  'Deutsch',
];

/// Bottom sheet that mirrors the "Select the language you'd like Rechitta to
/// speak in" wheel from the mockups.
class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key, required this.selected});

  final String selected;

  static Future<String?> show(BuildContext context, String selected) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LanguagePicker(selected: selected),
    );
  }

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  late final FixedExtentScrollController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = kLanguages.indexOf(widget.selected);
    if (_index < 0) _index = kLanguages.indexOf('English');
    _controller = FixedExtentScrollController(initialItem: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              "Select the language you'd like Rechitta to speak in",
              textAlign: TextAlign.center,
              style: AppTheme.body(size: 13.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 44,
                perspective: 0.004,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) => setState(() => _index = i),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: kLanguages.length,
                  builder: (context, i) {
                    final selected = i == _index;
                    return Center(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: selected
                            ? BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Text(
                          kLanguages[i],
                          style: AppTheme.body(
                            size: selected ? 18 : 15,
                            weight: selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context, kLanguages[_index]),
                child: Text(
                  'Select',
                  style: AppTheme.body(
                    size: 15,
                    weight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
