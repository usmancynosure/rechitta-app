# Rechitta — AI Real Estate Briefing (Flutter)

Rechitta turns a property project into a **living, voice-driven briefing** — every
unit, every price, every answer, always current, spoken in whatever language the
buyer speaks. This repo is the cross-platform **Flutter client** (iOS · Android ·
Web from one codebase).

> One Source of Truth.

## What's in here

The signature **Voice Briefing** screen, built to match the rechitta.com design:

- **Glowing blue orb** — a custom-painted, "breathing" sphere with the Rechitta mark
- **Conversational Q&A** — ask about layouts, ROI, payment plans, handover
- **Property cards** — hero render, blurb and headline stats (price / yield)
- **ROI analytics card** — projected yield, confidence, a gold trend line, community & safety scores
- **Language picker** — scroll-wheel sheet (Arabic, Hindi, Punjabi, English, Français, …)
- **Voice + text input** with quick-reply suggestion chips

All content is currently **mock data** (`lib/data/mock_data.dart`) and all imagery is
procedurally drawn with `CustomPainter`, so the app runs with **no bundled assets**.

## Project structure

```
lib/
├── main.dart                          # app entry + dark theme
├── theme/app_theme.dart               # colors + typography (Inter / Space Grotesk)
├── models/models.dart                 # message & card data types
├── data/mock_data.dart                # mock briefing + canned AI replies
├── screens/
│   └── voice_briefing_screen.dart     # the main screen
└── widgets/
    ├── glowing_orb.dart               # animated brand orb
    ├── rechitta_logo.dart             # the "R" mark + wordmark
    ├── chat_bubble.dart
    ├── property_card_widget.dart
    ├── roi_card_widget.dart           # trend line via CustomPainter
    ├── suggestion_chips.dart
    ├── message_input_bar.dart
    └── language_picker.dart
```

## Getting started

```bash
flutter pub get
flutter run            # choose an iOS simulator, Android device, or Chrome
```

Try typing **"ROI"**, **"payment plan"** or **"family rating"** (or tap a chip) to see
the AI reply with the matching card.

## Requirements

- Flutter 3.41+ (Dart 3.11+)
- Dependencies: `google_fonts`

## Roadmap

- Landing / "One Source of Truth" hero screen
- Floor-plan viewer & voice playback controls
- Real backend: speech-to-text, LLM answers, CRM-synced live inventory
- Analytics dashboard (opens, questions, buyer-intent signals)
