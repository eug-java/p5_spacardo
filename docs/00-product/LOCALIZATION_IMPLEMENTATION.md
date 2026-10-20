# Localization implementation - Phase 0.1

Status: implemented in source, not compiled or device-verified. Last updated: 2026-10-19.

## Scope

Eighteen locale resource files exist: `en`, `es`, `pt_BR`, `de`, `fr`, `ru`, `zh_CN`, `ja`, `ko`, `id`, `hi`, `ar`, `tr`, `vi`, `it`, `zh_TW`, `pl`, and `uk`.

The English ARB is the source-of-truth for message IDs. All UI shell strings have keys and preliminary translations. These translations were drafted automatically and **have not undergone native-speaker review**. Do not market them as release-quality translations yet.

## Implementation

- Flutter `gen-l10n` generates typed `AppLocalizations` classes during the Flutter tool run.
- The Flutter shell reads messages from `AppLocalizations.of(context)`.
- Language switching is available in Settings. Phase 0 selection is **in-memory only**; persistent preferences are a subsequent milestone.
- If the device locale is unsupported, English is used. Regional Chinese variants have independent resources; avoid collapsing them during locale resolution.
- Flutter's `Directionality` handles Arabic RTL at the framework level; all screens must still undergo manual RTL/accessibility testing.
- User-owned card fields are never automatically translated. Localization applies only to the application chrome.

## Adding a new message

1. Add a descriptive key and English value to `apps/mobile/lib/l10n/app_en.arb`.
2. Add the same key to each of the other 17 ARBs, with correct placeholders and locale-specific grammar.
3. Call `AppLocalizations.of(context)!.yourKey` instead of placing visible English strings directly in widgets.
4. Run `python3 scripts/check_localizations.py` and `flutter gen-l10n`.
5. Run widget tests, inspect text overflow and RTL layouts, and request native-language review.

## Release gates

Localization coverage (key count) is not linguistic quality. Obtain native-speaker review, test Arabic RTL, test narrow screens with long German/French strings, and verify CJK and Devanagari font fallbacks. Do not claim completion before those checks.
