# Anki File Compatibility Contract

Status: PROPOSED. No compatibility guarantee is currently verified by a real Anki round trip.

## Product promise
Import and export selected `.apkg` decks and `.colpkg` collection packages while preserving supported card data, media, settings, and review history when included. This is an independent implementation with no AnkiWeb synchronization.

## Required support matrix
| Area | MVP target | Limitation to document |
| --- | --- | --- |
| Legacy `.apkg` | Import/export selected tested variants | Older schemas vary |
| Modern `.apkg` | Import/export tested versions | SQLite package and compression versions differ |
| `.colpkg` | Validated collection restore and export | Destructive restore requires backup |
| Basic and Reversed | Full tested support | Note model variants require tests |
| Cloze | Full tested support | Rendering and template behavior vary |
| Images/audio | Safe local import and replay | Resource types and codecs vary |
| Review history | Preserve when included | Historical algorithm state must not be silently recalculated |
| Arbitrary HTML/CSS | Best effort | Unsafe content sanitized/restricted |
| Arbitrary template JavaScript | Not supported in MVP | Warn before import/export |
| Standalone `.anki2` / `.anki21` files | Not an MVP public import option | Read collections via supported packages |

## Import
File selection -> bounded ZIP inspection -> schema detection -> decode -> validation -> preview -> staging -> transaction. Merge modes must handle duplicate notes, identifiers, missing media, and historical reviews deterministically. The application must show potential loss before destructive actions.

## Export
Generate authentic Anki package structures for one explicitly named tested Anki Desktop version, not merely a ZIP archive. Validate by importing into an independent clean Anki profile. Deck export optionally excludes personal progress; collection export retains it as applicable.

## Safety
Reject path traversal, archive bombs, malformed SQLite, out-of-limit media, and direct access to privileged files. Imported card content is untrusted. Never execute arbitrary JavaScript with application privileges.

## Independence
Do not copy Anki code, bundled templates, logos, copyrighted example decks, or other original assets. Inspect public behavior and independently created test fixtures under applicable law. Track dependency provenance and legal review.

Sources: https://docs.ankiweb.net/importing/packaged-decks.html and https://docs.ankiweb.net/exporting.html .
