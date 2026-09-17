import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'floor_plan_card_widget.dart';
import 'property_card_widget.dart';
import 'roi_card_widget.dart';

/// Renders one conversation message: a user "pill" or an AI reply
/// (text plus an optional rich attachment).
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Text(
            '“${message.text}”',
            textAlign: TextAlign.center,
            style: AppTheme.body(size: 14.5, color: AppColors.textPrimary),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text != null)
            Text(
              '“${message.text}”',
              style: AppTheme.body(
                size: 14.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          if (message.attachment != null) ...[
            const SizedBox(height: 14),
            _buildAttachment(message.attachment!),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachment(MessageAttachment a) {
    if (a is PropertyCard) return PropertyCardWidget(data: a);
    if (a is FloorPlanCard) return FloorPlanCardWidget(data: a);
    if (a is RoiCard) return RoiCardWidget(data: a);
    return const SizedBox.shrink();
  }
}
