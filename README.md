# Mak Cik, Order! – Jelajah Rasa Malaysia

A 2D casual time-management game built with Flutter & Dart (Android, portrait, offline).
Help Mak Cik run her stall: read customer orders in local speech, tap **Hint** for the
Standard Malay translation, pick the right foods and quantities, and **Serve** before time runs out.

## Quick start

Requirements: Flutter **3.24 or newer** (Dart 3.5+), Android SDK, an Android phone or emulator.

```bash
# 1. Unzip, then inside the project folder:
./setup.sh          # macOS / Linux
setup.bat           # Windows

# 2. Run it
flutter run

# 3. Build an installable APK
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

`setup` runs `flutter create --platforms=android .` (which generates the `android/` folder
without touching `lib/`), renames the app label to "Mak Cik, Order!", and fetches packages.
Run the tests with `flutter test`.

## What's included

| Area | Implemented |
| --- | --- |
| Screens | Splash, Main Menu, Malaysia Map (food-trail), State Intro, Gameplay, Pause, Order Feedback, Level Result, Food Collection, Shop, Settings, How to Play |
| Content | All **13 states**, **3 levels each (39 levels)**, **50 foods** with descriptions, ingredients and cultural facts (BM + EN) |
| Gameplay | Dialect order generation, hint/translation, tap-to-add food cards, tray with +/−/clear, exact food+quantity validation, single-submission lock, timer, streak bonus, time bonus, completion bonus, 1–3 star rating |
| Progression | Level & state unlocks, best scores, stars, coins, food discovery — saved with SharedPreferences (with backup copy) |
| Shop | 20 cosmetic items across tables, decorations, aprons, signboards and themes; buy + equip; shown live on the stall |
| Settings | Music, sound effects, vibration, auto-translation, BM/EN UI, reset progress (with confirmation) |
| Reliability | Pause on app background, back-button handling, quit/restart confirmation, missing-image placeholders, guarded audio |
| Audio | Original generated SFX and a looping pentatonic background track (`assets/audio/`) |

Scoring follows the draft (section 4.3): correct +100, incorrect −20, streak +25,
remaining time +2/sec, completion +100. Tune them in `lib/utils/constants.dart`.

## Project structure

```
lib/
├── main.dart, app.dart
├── models/      food, state, order, customer, level, shop item, player progress
├── data/        foods, states, dialogue (dialects), levels, shop catalogue
├── services/    game session, order generation, progression, storage
├── screens/     all screens listed above
├── widgets/     customer panel/stall scene, food card, tray, dialogue, timer, score, pause
└── utils/       constants, audio manager, BM/EN strings
```

Everything is data-driven: adding a state = add foods in `foods_data.dart`, a state in
`states_data.dart` and a dialect profile in `dialogue_data.dart`. Levels are generated
automatically (edit `levels_data.dart` to hand-tune them).

## Adding artwork

The game currently draws each food as a coloured emoji badge. To use real illustrations,
put PNGs in `assets/images/foods/` (e.g. `akok.png`) and set `imagePath:
'assets/images/foods/akok.png'` on that food. If a file is missing, the placeholder is shown
instead of crashing.

## ⚠️ Before release: content review

As the draft requires, **the regional dialogue lines in `lib/data/dialogue_data.dart` are
drafts and have not been reviewed by local speakers.** Have native speakers check
spelling, wording and context for each state, then set `reviewed: true` on that profile
(the "draft dialogue" notice on the State Intro screen disappears automatically).
Food descriptions and cultural facts should also be verified. Regional foods are often
shared between states, and speech varies by district and community.
