#!/usr/bin/env bash
# One-time setup: generates the Android platform folder and names the app.
set -e
cd "$(dirname "$0")"
flutter create --platforms=android --org com.makcik --project-name mak_cik_order .
MANIFEST=android/app/src/main/AndroidManifest.xml
if [ -f "$MANIFEST" ]; then
  sed -i.bak 's/android:label="[^"]*"/android:label="Mak Cik, Order!"/' "$MANIFEST" && rm -f "$MANIFEST.bak"
fi
flutter pub get
echo "Done. Connect a phone or start an emulator, then run: flutter run"
