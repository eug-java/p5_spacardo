# P5 Spacardo localization architecture and requirements

Status: APPROVED architecture; translations and UI coverage are NOT implemented.

## Locale inventory

There are **18** requested locales, not 15. BCP 47 product tags and Flutter ARB filenames:

| BCP 47 tag | ARB filename | Language | Direction | Release readiness |
|---|---|---|---|---|
| `en` | `app_en.arb` | English | LTR | Planned, untranslated |
| `es` | `app_es.arb` | Spanish | LTR | Planned, untranslated |
| `pt-BR` | `app_pt_BR.arb` | Portuguese (Brazil) | LTR | Planned, untranslated |
| `de` | `app_de.arb` | German | LTR | Planned, untranslated |
| `fr` | `app_fr.arb` | French | LTR | Planned, untranslated |
| `ru` | `app_ru.arb` | Russian | LTR | Planned, untranslated |
| `zh-CN` | `app_zh_Hans_CN.arb` | Chinese (Simplified, Mainland) | LTR | Planned, untranslated |
| `ja` | `app_ja.arb` | Japanese | LTR | Planned, untranslated |
| `ko` | `app_ko.arb` | Korean | LTR | Planned, untranslated |
| `id` | `app_id.arb` | Indonesian | LTR | Planned, untranslated |
| `hi` | `app_hi.arb` | Hindi | LTR | Planned, untranslated |
| `ar` | `app_ar.arb` | Arabic | RTL | Planned, untranslated |
| `tr` | `app_tr.arb` | Turkish | LTR | Planned, untranslated |
| `vi` | `app_vi.arb` | Vietnamese | LTR | Planned, untranslated |
| `it` | `app_it.arb` | Italian | LTR | Planned, untranslated |
| `zh-TW` | `app_zh_Hant_TW.arb` | Chinese (Traditional, Taiwan) | LTR | Planned, untranslated |
| `pl` | `app_pl.arb` | Polish | LTR | Planned, untranslated |
| `uk` | `app_uk.arb` | Ukrainian | LTR | Planned, untranslated |

Only the English ARB is presently included and English is the **only enabled UI locale**.
Add each translated ARB after review, then let `AppLocalizations.supportedLocales` include it. Do not publish placeholder English copies as completed translations.

## Engineering rules

1. All repository documentation, code comments, commit templates, and contributor instructions are written in English.
2. End-user UI text comes exclusively from generated ARB localization resources; remove remaining hard-coded demo strings before the MVP release.
3. Use Flutter `gen-l10n`, `flutter_localizations`, and `intl` for ICU plural, select, and parameterized messages. Source language is English.
4. Locale preference order: explicit in-app selection > system locale > English. Store preference as a BCP 47 tag; keep `system` as distinct sentinel.
5. Prefer `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')` and `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')`.
6. Support Arabic RTL using direction-aware alignment, padding, icons, navigation and back controls. Do not manually reverse mixed-script text.
7. Do not translate card contents or imported Anki decks automatically. UI locale is independent of content language and TTS language.
8. Number/date formatting and plurals follow selected locale; due dates must preserve the user's intended calendar day across timezones.
9. Ensure fallback fonts support Arabic, Chinese, Japanese, Korean, Devanagari, Vietnamese and Cyrillic on all targets; test Unicode normalization, search and line breaking.
10. Never infer resource presence from locale registration; a language is only selectable when its reviewed translation file is complete.
11. Include Web RTL/LTR visual regression tests, Android/iOS accessibility checks and pseudo-localization overflow tests.
12. CI enforces key parity, ICU placeholder parity, no unintentional hard-coded UI strings and vetted translation review before activation.

## Implementation plan

- Phase 0: English ARB template, generated localization delegates, locale inventory and policy.
- Phase 1: extract all prototype strings and create 17 reviewed ARB translations.
- Phase 2: enable all 18 locales in application UI and verify plural rules, platform locale matching and RTL.
- Release gate: 100% mandatory keys translated and reviewed for each locale being advertised.

## References

- https://docs.flutter.dev/ui/internationalization
- https://docs.flutter.dev/release/breaking-changes/flutter-generate-i10n-source
