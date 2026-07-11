# 1% Better

Eine extrem minimalistische Android-App (Flutter), die genau ein Problem
löst: Menschen setzen sich große Ziele und verlieren die Motivation.
1% Better erinnert sie täglich daran, nur 1 % besser zu werden.

Kein Backend, keine Cloud, keine Werbung, kein Tracking. Alles läuft
offline, lokal auf dem Gerät.

---

## Inhaltsverzeichnis

1. [Architektur & Dateistruktur](#architektur--dateistruktur)
2. [Voraussetzungen](#voraussetzungen)
3. [Installation & lokaler Start](#installation--lokaler-start)
4. [App-Icon & Splash Screen erzeugen](#app-icon--splash-screen-erzeugen)
5. [Google Play Billing einrichten](#google-play-billing-einrichten)
6. [Release-Build erzeugen (signierte APK/AAB)](#release-build-erzeugen)
7. [Vor der Veröffentlichung](#vor-der-veröffentlichung)
8. [Bekannte Einschränkungen](#bekannte-einschränkungen)

---

## Architektur & Dateistruktur

Clean-Architecture-inspirierte, aber bewusst schlanke Struktur (keine
Überkonstruktion für eine Ein-Screen-App):

```
lib/
  core/
    constants/app_constants.dart   # zentrale Texte, Keys, Limits
    theme/app_theme.dart           # Material 3 Light/Dark Theme
    utils/date_utils.dart          # Datum-Hilfsfunktionen
  models/
    daily_entry.dart               # Eintrags-Modell + Hive-Adapter
    streak_data.dart                # Streak-Modell
  services/
    storage_service.dart           # Hive-Zugriff (einzige Datenquelle)
    notification_service.dart      # lokale tägliche Erinnerung
    billing_service.dart           # Google Play Billing
    pdf_export_service.dart        # PDF-Export (Premium)
  providers/
    service_providers.dart         # DI-Wiring für Riverpod
    entry_provider.dart            # State: Einträge, Verlauf, Streak
    settings_provider.dart         # State: Dark Mode, Benachrichtigungen
    premium_provider.dart          # State: Premium-Status
  routes/
    app_router.dart                # go_router Konfiguration
  features/
    home/                         # Screen 1: der einzige Kern-Screen
    settings/                     # Screen 2: Einstellungen
    premium/                      # Premium-Upgrade-Screen
    legal/                        # Datenschutz & Impressum
  widgets/
    app_logo.dart
    confetti_overlay.dart
  main.dart                       # Einstiegspunkt, Service-Init
```

Designprinzip: **Ein Zweck, ein Screen.** Keine Projekte, keine
Kategorien, keine Social-Features, kein KI-Chat. Jede neue Funktion
muss sich fragen lassen, ob sie diesem Prinzip widerspricht.

---

## Voraussetzungen

- Flutter SDK ≥ 3.24 (stabiler Channel) – https://docs.flutter.dev/get-started/install
- Android SDK (via Android Studio) mit installierter Platform 34
- Ein physisches Android-Gerät oder ein Emulator (API 23+)
- Für Billing-Tests: ein Google-Play-Konsole-Zugang mit konfiguriertem
  Testprodukt (siehe Abschnitt Billing)

Prüfen, ob alles korrekt eingerichtet ist:

```bash
flutter doctor
```

---

## Installation & lokaler Start

```bash
# 1. In den Projektordner wechseln
cd one_percent_better

# 2. Abhängigkeiten installieren
flutter pub get

# 3. Verbundene Geräte prüfen
flutter devices

# 4. App im Debug-Modus starten
flutter run
```

Die App ist beim ersten Start sofort nutzbar. Es ist keine
Server-/Backend-Konfiguration nötig, da alle Daten lokal in einer
Hive-Datenbank auf dem Gerät gespeichert werden.

### Hinweis zu `hive_generator` / Codegen

Der `DailyEntry`-Hive-Adapter ist **manuell** implementiert
(`lib/models/daily_entry.dart`), damit das Projekt ohne vorherigen
`build_runner`-Lauf sofort kompiliert. `hive_generator`/`build_runner`
sind trotzdem als Dev-Dependency enthalten, falls das Modell später
erweitert und der Adapter neu generiert werden soll:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## App-Icon & Splash Screen erzeugen

Die Rohgrafiken liegen bereits unter `assets/icon/` (generiert):

- `app_icon.png` – quadratisches App-Icon (schwarzer Hintergrund, "1%"
  in Grün, "BETTER" in Weiß)
- `app_icon_foreground.png` – transparente Vordergrundebene für
  adaptive Android-Icons
- `splash_logo.png` – Logo für den Splash Screen

Icons und Splash Screen für alle Android-Auflösungen generieren:

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Das erzeugt automatisch alle `mipmap-*`-Icon-Auflösungen sowie die
Splash-Screen-Ressourcen (inkl. Android-12-Splash-API).

Möchtest du ein eigenes, professionelles Icon verwenden: ersetze
einfach die drei PNGs unter `assets/icon/` (gleiche Dateinamen,
mindestens 1024×1024 px) und führe die beiden Befehle erneut aus.

---

## Google Play Billing einrichten

1. App in der [Google Play Console](https://play.google.com/console)
   anlegen (Paketname: `com.onepercentbetter.app` – oder anpassen, s.u.).
2. Unter **Monetarisierung → Abos** ein neues Abo anlegen mit der
   Produkt-ID:
   ```
   one_percent_better_premium_monthly
   ```
   (muss exakt mit `AppConstants.premiumSubscriptionId` übereinstimmen)
3. Preis auf 0,99 € (monatlich) setzen, Abo aktivieren.
4. Für Tests: Tester-E-Mail-Adressen unter **Einstellungen →
   Lizenztests** hinterlegen, oder eine interne Testschiene mit
   entsprechenden Test-Accounts nutzen.
5. Die App muss für Billing-Tests über die Play Console (interner
   Test-Track) installiert werden – lokale Debug-Builds direkt aus
   Android Studio können keine echten Käufe simulieren.

Der komplette Kauf-Flow (`buyPremium`, `restorePurchases`,
Purchase-Stream-Handling) ist bereits in
`lib/services/billing_service.dart` implementiert.

### Paketname ändern

Falls du einen eigenen Paketnamen verwenden möchtest, ersetze
`com.onepercentbetter.app` an folgenden Stellen:

- `android/app/build.gradle` (`namespace`, `applicationId`)
- `android/app/src/main/AndroidManifest.xml` (Package wird automatisch
  aus `build.gradle` übernommen)
- Verzeichnisstruktur unter `android/app/src/main/kotlin/...`
  entsprechend anpassen
- `android/app/src/main/kotlin/.../MainActivity.kt` (Package-Deklaration)

---

## Release-Build erzeugen

### 1. Signing-Key erzeugen (einmalig)

```bash
keytool -genkey -v -keystore ~/one-percent-better-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias one_percent_better
```

### 2. Signing konfigurieren

```bash
cp android/key.properties.example android/key.properties
```

`android/key.properties` mit den echten Werten befüllen
(Store-Passwort, Key-Passwort, Alias, absoluter Pfad zum `.jks`-File).
Diese Datei ist in `.gitignore` ausgeschlossen und darf **niemals**
ins Repository gelangen.

### 3. Build erzeugen

App Bundle (empfohlen für Play Store Upload):
```bash
flutter build appbundle --release
# Ausgabe: build/app/outputs/bundle/release/app-release.aab
```

APK (z. B. für direkte Installation/Tests):
```bash
flutter build apk --release
# Ausgabe: build/app/outputs/flutter-apk/app-release.apk
```

---

## Vor der Veröffentlichung

Checkliste, bevor die App im Play Store live geht:

- [ ] `android/app/src/main/kotlin/.../MainActivity.kt` und
      `applicationId` ggf. auf eigenen Paketnamen anpassen
- [ ] **Impressum** (`lib/features/legal/impressum_screen.dart`):
      alle `[Platzhalter]` durch echte Betreiberdaten ersetzen
      (rechtlich zwingend erforderlich, § 5 TMG)
- [ ] **Datenschutzerklärung**: Kontakt-E-Mail final prüfen/anpassen
- [ ] Store-Listing-Texte aus `store_listing_de.md` in die Play
      Console übernehmen
- [ ] Screenshots gemäß Vorschlägen in `store_listing_de.md` erstellen
- [ ] Eigenes, finales App-Icon einsetzen (falls das generierte
      Platzhalter-Icon nicht final verwendet werden soll)
- [ ] Premium-Abo in der Play Console final testen (echter Kauf-Flow
      über internen Test-Track)
- [ ] `flutter analyze` und `flutter test` fehlerfrei durchlaufen lassen
- [ ] Datenschutzerklärung als öffentlich erreichbare URL in der Play
      Console hinterlegen (kann z. B. der In-App-Text als gehostete
      Version sein)

---

## Bekannte Einschränkungen

- **Widgets** (Home-Screen-Widget für den Streak) sind als
  Premium-Feature beworben, aber in diesem Lieferumfang als natives
  Android-Widget noch nicht implementiert – dies erfordert ein
  separates `home_widget`-Package + natives Kotlin-Widget-Layout und
  sollte als eigener Ausbauschritt umgesetzt werden.
- **Statistiken** (Wochen-/Monatsübersicht) sind im Premium-Screen als
  Vorteil aufgeführt; eine dedizierte Statistik-Detailansicht ist noch
  nicht als eigener Screen ausgebaut und lässt sich auf Basis von
  `StorageService.getAllEntries()` ergänzen.
- Der PDF-Export nutzt aktuell die im Speicher geladenen Einträge
  (`entryProvider`); bei sehr großer Historie kann `getAllEntries()`
  direkt für den Export verwendet werden.

---

## Lizenz / Rechtliches

Dieses Projekt ist eine Vorlage. Impressum und Datenschutzerklärung
enthalten Platzhalter, die vor Veröffentlichung zwingend durch echte,
rechtlich geprüfte Angaben ersetzt werden müssen.
