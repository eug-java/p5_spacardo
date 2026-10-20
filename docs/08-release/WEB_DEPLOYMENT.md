# Web and PWA Deployment

Status: DRAFT until a real browser build is available.

## Architecture
Web is a static HTTPS-hosted Flutter application with a compiled Rust WASM scheduling/codec core and SQLite WASM storage. There is no application backend processing user cards. A web host/CDN may still retain technical access logs.

## Build and hosting prerequisites
1. Pin supported Flutter/Rust versions and build the Web target in CI.
2. Verify WASM files are emitted and load in Chrome, Edge, Firefox and Safari versions in the tested matrix.
3. Serve `application/wasm` for `.wasm` files and `application/javascript` for JS assets.
4. Configure correct cache lifetimes and cache busting for application releases; protect user OPFS/IndexedDB data during updates.
5. Serve HTTPS and test any required COOP/COEP headers for the actual SQLite/worker configuration; avoid unnecessary cross-origin isolation.
6. Manage app shell/offline caching with a tested Service Worker, rather than assuming Flutter creates one automatically.
7. Block unexpected third-party assets, trackers and cross-origin network access where feasible.

## Web verification
- Install PWA where supported; verify online first load and offline revisit.
- Create notes/cards, close/reopen tab/browser, verify persistence.
- Test multi-tab migration/write locking and storage quota error behavior.
- Import and export an APKG with media and verify independently with Anki Desktop.
- Validate browser worker memory limits and archive cancellation.
- Test content security policy (CSP) and that imported card HTML cannot access privileged APIs.

## Privacy and operations
Document access log retention, host/CDN processors, country/region and actual collected network metadata in Privacy Policy. Warn users that clearing site data or browser eviction may delete the local collection. Offer manual external backup to a user-selected file.

Sources: https://docs.flutter.dev/platform-integration/web/building ; https://drift.simonbinder.eu/platforms/web/ .
