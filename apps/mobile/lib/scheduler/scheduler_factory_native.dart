import 'dart:ffi';
import 'dart:io';

import 'fsrs_api.dart';
import 'native_fsrs.dart';

/// Loads the native FSRS engine on supported platforms.
/// Returns null if the required library is unavailable.
FsrsEngine? createFsrsEngine() {
  try {
    if (Platform.isIOS) {
      return NativeFsrsEngine(DynamicLibrary.process());
    }

    if (Platform.isLinux) {
      final configuredPath = Platform.environment['SPACARDO_FSRS_LIBRARY'];

      final libraryPath = configuredPath ??
          '${File(Platform.resolvedExecutable).parent.path}/libsrs_bridge.so';

      return NativeFsrsEngine(
        DynamicLibrary.open(libraryPath),
      );
    }

    if (Platform.isAndroid) {
      return NativeFsrsEngine(
        DynamicLibrary.open('libsrs_bridge.so'),
      );
    }

    return null;
  } on ArgumentError {
    return null;
  } on UnsupportedError {
    return null;
  }
}
