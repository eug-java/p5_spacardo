# Dependency License Compliance

Status: PROPOSED.

## Policy
Every direct and transitive dependency, asset, icon, font, binary and generated library must have a recorded origin, exact version/commit, license, notice obligations, redistribution constraints and reviewer. Changes without provenance must not merge.

## Open-source model
The public GitHub repository is planned, but the project owner has not yet formally selected a license for original source. The default recommendation is Apache-2.0, subject to final decision. Do not claim an open-source license until a correct root LICENSE exists. There must be no assumption that publishing code on GitHub means it is public domain.

## Required checks
- Record exact versions and licenses of Flutter, Riverpod, Drift, flutter_rust_bridge, fsrs-rs and their transitive dependencies.
- Add copyright and MIT/BSD/Apache notices wherever mandated in source and redistributed bundles.
- Review distribution implications before adding any GPL, LGPL or AGPL components; do not automatically block them as unlawful, but require explicit legal/design review.
- Do not incorporate Anki AGPL code or its bundled assets merely because they are publicly accessible.
- Run dependency scanning in CI; audit license changes on upgrades and keep historical bill of materials.
- Keep third-party licenses in `THIRD_PARTY_NOTICES` or equivalent generated inventory in final releases.

## Approval checklist
- [ ] License owner decision recorded and LICENSE file checked in.
- [ ] Software and content provenance complete.
- [ ] Direct/transitive dependency inventory generated from pinned versions.
- [ ] Binary distributions contain required legal notices.
- [ ] App Store and Play Store distribution reviewed against adopted licenses.
