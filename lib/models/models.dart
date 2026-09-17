import 'package:flutter/material.dart';

enum Sender { user, ai }

/// A single message in the briefing conversation. It may carry an optional
/// rich attachment (a property card or an ROI analytics card).
class ChatMessage {
  const ChatMessage({
    required this.sender,
    this.text,
    this.attachment,
  });

  final Sender sender;
  final String? text;
  final MessageAttachment? attachment;

  bool get isUser => sender == Sender.user;
}

/// Base type for rich content rendered under an AI message.
abstract class MessageAttachment {
  const MessageAttachment();
}

/// A property showcase card: hero image, title, blurb and two headline stats.
class PropertyCard extends MessageAttachment {
  const PropertyCard({
    required this.title,
    required this.description,
    required this.gradient,
    required this.stats,
  });

  final String title;
  final String description;
  final List<Color> gradient; // stand-in for a render/photo
  final List<PropertyStat> stats;
}

class PropertyStat {
  const PropertyStat({required this.value, required this.label});
  final String value;
  final String label;
}

/// An analytics card: projected yield, confidence, a small trend line and
/// community scores.
class RoiCard extends MessageAttachment {
  const RoiCard({
    required this.yieldPercent,
    required this.confidence,
    required this.peakLabel,
    required this.baselineLabel,
    required this.trend,
    required this.communityScore,
    required this.grade,
    required this.safetyIndex,
  });

  final String yieldPercent;
  final String confidence;
  final String peakLabel;
  final String baselineLabel;
  final List<double> trend; // 0..1 normalized points
  final String communityScore;
  final String grade;
  final String safetyIndex;
}

/// A quick-reply suggestion chip.
class Suggestion {
  const Suggestion(this.label, this.icon);
  final String label;
  final IconData icon;
}
