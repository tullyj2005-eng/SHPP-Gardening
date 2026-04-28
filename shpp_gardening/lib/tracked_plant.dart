class TrackedPlant {
  final String name;
  final DateTime lastWatered;
  final Duration thirstDuration;

  TrackedPlant({
    required this.name,
    required this.lastWatered,
    this.thirstDuration = const Duration(hours: 6),
  });

  double get waterProgress {
    final timePassed = DateTime.now().difference(lastWatered);
    double progress = timePassed.inSeconds / thirstDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }
}