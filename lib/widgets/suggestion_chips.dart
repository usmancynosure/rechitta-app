import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Horizontal row of quick-reply chips shown above the input bar.
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<Suggestion> suggestions;
  final ValueChanged<Suggestion> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: suggestions.length,
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final s = suggestions[i];
          return _Chip(suggestion: s, onTap: () => onTap(s));
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.suggestion, required this.onTap});
  final Suggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(suggestion.icon, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 7),
              Text(
                suggestion.label,
                style: AppTheme.body(size: 13, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
