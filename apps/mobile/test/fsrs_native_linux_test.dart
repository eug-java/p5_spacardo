import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/scheduler/native_fsrs.dart';

void main() {
  final path = Platform.environment['SPACARDO_FSRS_LIBRARY'];
  final enabled = Platform.isLinux && path != null && path.isNotEmpty;
  test('real native Rust FSRS returns valid rating choices', () {
    final engine = NativeFsrsEngine(DynamicLibrary.open(path!));
    final choices =
        engine.preview(stability: null, difficulty: null, elapsedDays: 0);
    for (final rating in [1, 2, 3, 4]) {
      final option = choices.forRating(rating);
      expect(option.intervalDays.isFinite, isTrue);
      expect(option.intervalDays, greaterThanOrEqualTo(0));
      expect(option.stability, greaterThan(0));
      expect(option.difficulty, inInclusiveRange(0.0001, 10));
    }
  }, skip: enabled ? false : 'Linux Rust shared library not configured');
}
