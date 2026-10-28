@echo off
REM One-time setup on Windows: generates the Android folder and names the app.
cd /d "%~dp0"
call flutter create --platforms=android --org com.makcik --project-name mak_cik_order .
powershell -NoProfile -Command "(Get-Content android\app\src\main\AndroidManifest.xml) -replace 'android:label=\"[^\"]*\"','android:label=\"Mak Cik, Order!\"' | Set-Content android\app\src\main\AndroidManifest.xml"
call flutter pub get
echo Done. Connect a phone or start an emulator, then run: flutter run
