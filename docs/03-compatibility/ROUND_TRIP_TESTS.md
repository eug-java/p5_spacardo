# Anki Import/Export Round-Trip Test Plan

Status: PROPOSED. Golden fixtures must be created with legitimately obtained Anki Desktop versions and licensed/original sample material.

## Test matrix
| Test | Expected outcome |
| --- | --- |
| Basic one-way deck | Fields and card count preserved |
| Basic reversed deck | Both card directions preserved |
| Cloze notes | All required cloze cards generated |
| Nested decks/tags | Structure preserved |
| HTML/CSS with MathJax | Supported rendering retained |
| Image/audio package | Files referenced and replayed locally |
| Full collection with history | Ratings/due dates retained within declared compatibility |
| Import same package twice | No unexpected duplicates |
| Export APKG -> clean Anki | Anki opens package without repair or missing cards |
| Export COLPKG -> clean Anki profile | Collection and review history restored |
| Anki -> app -> Anki | Differences match explicitly documented exclusions |
| Invalid ZIP / zip slip / bomb | Safe failure without damaging active collection |
| Interrupted restore | Existing collection remains intact |
| Browser out of storage | Action fails clearly; collection remains consistent |

## Procedure
1. Record exact Anki version, OS, fixture creation steps, package variant, and checksum.
2. Export the fixture from Anki Desktop; verify metadata and expected counts.
3. Import it into a clean app instance and compare deck, note, card, template, media, state, and event counts and canonical content.
4. Export from the app, then import into a separate clean Anki profile.
5. Diff canonicalized records and record every intentional mapping or loss.
6. Run the same fixture on Android, iOS, Web Chromium, Firefox, and Safari where supported.
7. Attach logs and result evidence before marking the feature VERIFIED.

## Pass/fail
Do not equate a readable archive with a successful Anki import. Pass requires a real Anki Desktop import, no silent data loss within declared features, and reproducible fixture/target versions. Keep unsupported cases explicitly marked rather than hiding them.
