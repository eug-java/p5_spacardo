# Anki ZIP inspector vs real importer

The current Rust and Python inspectors read **ZIP directory metadata only**. They check that a collection-like file is present and reject suspicious names and excessively large files. They DO NOT parse SQLite, verify JSON media maps, decode Zstandard, preserve note IDs, import scheduling history, or generate valid Anki exports.

Do not label a ZIP as supported simply because it passes the inspector. The format profiles `.apkg` / `.colpkg` and SQLite/Zstandard internals must be tested against real Anki-generated files. Authoritative manual: https://docs.ankiweb.net/importing/packaged-decks.html .

The Python preflight utility is a developer-only helper; production importer must enforce the equivalent and additional limits directly in native/WASM code, including streaming guards and transitive resource limits.
