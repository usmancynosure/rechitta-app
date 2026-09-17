import '../models/models.dart';
import '../theme/app_images.dart';
import 'package:flutter/material.dart';

/// A single slide in the project overview deck.
class ProjectSlide {
  const ProjectSlide({
    required this.section,
    required this.title,
    required this.caption,
    this.backgroundImage,
    this.overviewText,
    this.bullets,
    this.floorPlanImage,
    this.specs,
  });

  final String section; // e.g. "SECTION 1"
  final String title; // e.g. "Project Overview"
  final String caption; // spoken caption shown by the voice bar

  final String? backgroundImage;
  final String? overviewText; // free-text body
  final List<String>? bullets; // bulleted content (e.g. payment plan)
  final String? floorPlanImage; // renders a plan block
  final List<FloorPlanSpec>? specs;
}

class ProjectData {
  ProjectData._();

  static const String name = 'HARBOUR VANGUARDE';
  static const String developer = 'WestF5 Developments';

  static const List<ProjectSlide> slides = [
    ProjectSlide(
      section: 'SECTION 1',
      title: 'Project Overview',
      caption: "I've curated the most exclusive availability for you.",
      backgroundImage: AppImages.masterplanAerial,
      overviewText:
          'A waterfront landmark of curved glass and warm timber, Harbour '
          'Vanguarde pairs zero-edge views with a smart-concierge lifestyle — '
          'a marina promenade, infinity pools and a private residents’ club.',
    ),
    ProjectSlide(
      section: 'SECTION 2',
      title: 'The Residences',
      caption: 'Interiors designed around light and the water beyond.',
      backgroundImage: AppImages.livingHarbourView,
      overviewText:
          'Floor-to-ceiling glass frames the harbour from every living space. '
          'Neutral palettes, natural stone and integrated lighting make each '
          'residence feel effortless, day to night.',
    ),
    ProjectSlide(
      section: 'SECTION 3',
      title: 'Payment Plans',
      caption: 'A 30/70 plan, structured through handover.',
      backgroundImage: AppImages.harbourTowerDusk,
      bullets: [
        '5% on booking',
        '15% within 60 days',
        '5% in January 2027',
        '5% in July 2027',
        '70% on completion (December 2027)',
        'All amounts in AED',
      ],
    ),
    ProjectSlide(
      section: 'SECTION 4',
      title: 'Floor Plan',
      caption: 'Type A, 2-bedroom — harbour facing, dual en-suite.',
      floorPlanImage: AppImages.twoBedTypeA,
      specs: [
        FloorPlanSpec(icon: Icons.crop_free_rounded, value: '1,220 SQ FT', label: 'Area'),
        FloorPlanSpec(icon: Icons.sell_outlined, value: 'AED 0.8M', label: 'Price'),
        FloorPlanSpec(icon: Icons.sailing_outlined, value: 'Harbour Facing', label: 'View'),
        FloorPlanSpec(icon: Icons.meeting_room_outlined, value: 'Dual En-suite', label: 'Baths'),
      ],
    ),
  ];
}
