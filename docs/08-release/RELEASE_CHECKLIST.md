# Android, iOS, and Web Release Checklist

Status: DRAFT. No production release has been verified.

## Product and tests
- [ ] MVP requirement IDs satisfied and test evidence attached.
- [ ] Rust FSRS parity verified on three platforms using pinned versions.
- [ ] All declared Anki import/export formats validated against real Anki Desktop.
- [ ] Media, full collection restore, backup and undo fully tested.
- [ ] Accessibility (screen reader, text scaling, keyboard controls) reviewed.
- [ ] Offline/PWA startup and IndexedDB/OPFS storage tested in target browsers.
- [ ] Malicious input, disk-full/quota and interrupted import tests pass.

## Reproducible packaging
- [ ] Flutter, Rust, Android SDK, Xcode targets and dependencies pinned.
- [ ] Android release AAB signed; target API and Play policy checked.
- [ ] iOS archive signed and validated by TestFlight/App Store workflow.
- [ ] Web static assets and WASM served over HTTPS with correct MIME/headers.
- [ ] Production build does not embed signing keys, certificates, analytics SDK surprises, or secrets.

## Legal and public repository
- [ ] Final, cleared product name and original icon approved.
- [ ] Project license and notices committed; all third-party licenses and assets audited.
- [ ] Copyright provenance for included demo decks and media documented.
- [ ] Privacy Policy finalized with actual host/CDN and SDK disclosure.
- [ ] Google Data safety and Apple privacy labels match actual processing.
- [ ] Contributor guide, support contact, vulnerability policy and changelog available in English.
- [ ] Public repo contains no credentials, user-generated private data, or copyrighted test files.

## Recovery and communication
- [ ] Tested restore procedure and limits described to users.
- [ ] Known compatibility gaps and supported Anki versions listed.
- [ ] Versioned changelog and migration notes published.
- [ ] Rollback plan exists for Web deployment and database migrations.
- [ ] Store listing accurately describes independent Anki-file compatibility.
