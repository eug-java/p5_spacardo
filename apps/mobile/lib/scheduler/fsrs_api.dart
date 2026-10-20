/// Stable Dart-facing DTOs. The native scheduler is an experimental adapter.
class FsrsChoice {
  final double intervalDays;
  final double stability;
  final double difficulty;
  const FsrsChoice(this.intervalDays, this.stability, this.difficulty);
}

class FsrsChoices {
  final FsrsChoice again, hard, good, easy;
  const FsrsChoices(this.again, this.hard, this.good, this.easy);
  FsrsChoice forRating(int rating) => switch (rating) {
    1 => again,
    2 => hard,
    3 => good,
    4 => easy,
    _ => throw ArgumentError.value(rating, 'rating'),
  };
}

abstract interface class FsrsEngine {
  FsrsChoices preview({
    required double? stability,
    required double? difficulty,
    required int elapsedDays,
    double retention = 0.90,
  });
}
