import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_images.dart';

/// Mock briefing content mirroring the rechitta.com product mockups.
class MockData {
  MockData._();

  static const String projectName = 'HARBOUR VANGUARDE';

  static final List<ChatMessage> conversation = [
    const ChatMessage(
      sender: Sender.user,
      text: 'Tell me about the project and 2 bed structural layout.',
    ),
    const ChatMessage(
      sender: Sender.ai,
      text:
          'Here are the architectural layouts for the Type A 2-bedroom units. '
          'These feature panoramic harbour views.',
      attachment: PropertyCard(
        title: 'Architectural Mastery',
        description:
            'Designed by atelier Vanguarde, these residences redefine coastal '
            'luxury with zero-edge views & integrated smart-concierge technology.',
        gradient: [Color(0xFF3E4A63), Color(0xFF1B2436)],
        imageAsset: AppImages.harbourTowerDusk,
        stats: [
          PropertyStat(value: 'AED 2.4M', label: 'Starting From'),
          PropertyStat(value: '8.4%', label: 'Yield Projection'),
        ],
      ),
    ),
    const ChatMessage(
      sender: Sender.user,
      text: 'Tell me about the new project and the market returns.',
    ),
    const ChatMessage(
      sender: Sender.ai,
      text: 'Executing multi-variable projection & qualitative demographic indexing…',
      attachment: RoiCard(
        yieldPercent: '8.5%',
        confidence: '94.2%',
        peakLabel: 'PEAK: 8.5% (Q4)',
        baselineLabel: 'BASELINE: 8.2%',
        trend: [0.30, 0.28, 0.42, 0.40, 0.55, 0.68, 0.72, 0.88, 0.95],
        communityScore: '9.2/10',
        grade: 'A+',
        safetyIndex: '9.8',
      ),
    ),
  ];

  static const List<Suggestion> suggestions = [
    Suggestion('Expected ROI?', Icons.trending_up_rounded),
    Suggestion('Floor plan?', Icons.grid_on_rounded),
    Suggestion('Family living rating?', Icons.family_restroom_rounded),
    Suggestion('Payment plans?', Icons.payments_outlined),
    Suggestion('Handover date?', Icons.event_available_outlined),
  ];

  /// Canned replies keyed loosely by intent, so the demo feels responsive.
  static ChatMessage replyFor(String prompt) {
    final p = prompt.toLowerCase();
    if (p.contains('roi') || p.contains('return') || p.contains('yield')) {
      return const ChatMessage(
        sender: Sender.ai,
        text:
            'Executing multi-variable projection & qualitative demographic indexing…',
        attachment: RoiCard(
          yieldPercent: '8.5%',
          confidence: '94.2%',
          peakLabel: 'PEAK: 8.5% (Q4)',
          baselineLabel: 'BASELINE: 8.2%',
          trend: [0.30, 0.28, 0.42, 0.40, 0.55, 0.68, 0.72, 0.88, 0.95],
          communityScore: '9.2/10',
          grade: 'A+',
          safetyIndex: '9.8',
        ),
      );
    }
    if (p.contains('floor') || p.contains('layout') || p.contains('plan') &&
        !p.contains('payment')) {
      return const ChatMessage(
        sender: Sender.ai,
        text:
            'Here is the Type A 2-bedroom floor plan — a harbour-facing layout '
            'with dual en-suites.',
        attachment: FloorPlanCard(
          title: '2 Bedroom',
          imageAsset: AppImages.twoBedTypeA,
          specs: [
            FloorPlanSpec(icon: Icons.crop_free_rounded, value: '1,220 SQ FT', label: 'Area'),
            FloorPlanSpec(icon: Icons.sell_outlined, value: 'AED 0.8M', label: 'Price'),
            FloorPlanSpec(icon: Icons.sailing_outlined, value: 'Harbour Facing', label: 'View'),
            FloorPlanSpec(icon: Icons.meeting_room_outlined, value: 'Dual En-suite', label: 'Baths'),
          ],
        ),
      );
    }
    if (p.contains('payment')) {
      return const ChatMessage(
        sender: Sender.ai,
        text:
            'The 30/70 plan: 5% on booking, 15% within 60 days, staged '
            'instalments through 2027, and 70% on completion (December 2027). '
            'All amounts in AED.',
      );
    }
    if (p.contains('family') || p.contains('rating') || p.contains('living')) {
      return const ChatMessage(
        sender: Sender.ai,
        text:
            'Community Score is 9.2/10 (Grade A+). Schools, parks and a marina '
            'promenade sit within a 10-minute radius, with a Public Safety '
            'Index of 9.8.',
      );
    }
    if (p.contains('handover') || p.contains('date') || p.contains('complete')) {
      return const ChatMessage(
        sender: Sender.ai,
        text: 'Handover is scheduled for December 2027, with 70% due on completion.',
      );
    }
    return const ChatMessage(
      sender: Sender.ai,
      text:
          'Here are the architectural layouts for the Type A 2-bedroom units. '
          'These feature panoramic harbour views.',
      attachment: PropertyCard(
        title: 'Architectural Mastery',
        description:
            'Designed by atelier Vanguarde, these residences redefine coastal '
            'luxury with zero-edge views & integrated smart-concierge technology.',
        gradient: [Color(0xFF3E4A63), Color(0xFF1B2436)],
        imageAsset: AppImages.harbourTowerDusk,
        stats: [
          PropertyStat(value: 'AED 2.4M', label: 'Starting From'),
          PropertyStat(value: '8.4%', label: 'Yield Projection'),
        ],
      ),
    );
  }
}
