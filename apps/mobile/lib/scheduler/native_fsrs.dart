import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'fsrs_api.dart';

final class _Option extends Struct {
  @Float()
  external double intervalDays;
  @Float()
  external double stability;
  @Float()
  external double difficulty;
}

final class _Preview extends Struct {
  external _Option again;
  external _Option hard;
  external _Option good;
  external _Option easy;
}

typedef _PreviewNative = Int32 Function(
    Uint8, Float, Float, Uint32, Float, Pointer<_Preview>);
typedef _PreviewDart = int Function(
    int, double, double, int, double, Pointer<_Preview>);

/// Loads a library previously built and packaged for the current target.
/// Not available on Web; use the platform conditional import.
class NativeFsrsEngine implements FsrsEngine {
  final _PreviewDart _preview;
  NativeFsrsEngine(DynamicLibrary library)
      : _preview = library.lookupFunction<_PreviewNative, _PreviewDart>(
            'spacardo_fsrs_preview_v1');

  @override
  FsrsChoices preview({
    required double? stability,
    required double? difficulty,
    required int elapsedDays,
    double retention = 0.90,
  }) {
    if ((stability == null) != (difficulty == null)) {
      throw ArgumentError('Both memory components must be present or absent');
    }
    if (!retention.isFinite || retention < 0.7 || retention > 0.99) {
      throw ArgumentError.value(retention, 'retention');
    }
    if (elapsedDays < 0 || elapsedDays > 0xffffffff) {
      throw ArgumentError.value(elapsedDays, 'elapsedDays');
    }
    final out = calloc<_Preview>();
    try {
      final status = _preview(stability == null ? 0 : 1, stability ?? 0,
          difficulty ?? 0, elapsedDays, retention, out);
      if (status != 0) {
        throw StateError('Native FSRS rejected preview: $status');
      }
      FsrsChoice convert(_Option option) {
        final interval = option.intervalDays;
        final stability = option.stability;
        final difficulty = option.difficulty;
        if (!interval.isFinite ||
            interval < 0 ||
            !stability.isFinite ||
            stability <= 0 ||
            !difficulty.isFinite ||
            difficulty <= 0 ||
            difficulty > 10) {
          throw StateError('Native FSRS returned invalid values');
        }
        return FsrsChoice(interval, stability, difficulty);
      }

      return FsrsChoices(convert(out.ref.again), convert(out.ref.hard),
          convert(out.ref.good), convert(out.ref.easy));
    } finally {
      calloc.free(out);
    }
  }
}
