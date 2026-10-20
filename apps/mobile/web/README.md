Platform files will be generated with `flutter create . --platforms=android,ios,web`.
Web support requires the exact Drift Worker and sqlite3.wasm assets for the
pinned dependency versions, obtained from the upstream Drift instructions.
No fake/mock wasm binaries are included in this archive.
Do not deploy this directory as-is.
