import 'dart:ffi';
import 'dart:io';
import 'fsrs_api.dart';
import 'native_fsrs.dart';

/// Returns null until native artifacts are actually packaged.
/// No fallback scheduler is allowed.
FsrsEngine? createFsrsEngine() {
  try {
    if (!Platform.isIOS && !Platform.isAndroid) return null;
    final library = Platform.isIOS
        ? DynamicLibrary.process()
        : DynamicLibrary.open('libsrs_bridge.so');
    return NativeFsrsEngine(library);
  } on ArgumentError {
    return null;
  } on UnsupportedError {
    return null;
  }
}
