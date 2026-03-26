class WalkingProgress {
  const WalkingProgress({
    required this.stepCount,
    required this.distanceKm,
    required this.sessions,
    required this.usedLiveLocation,
  });

  static const empty = WalkingProgress(
    stepCount: 0,
    distanceKm: 0,
    sessions: 0,
    usedLiveLocation: false,
  );

  final int stepCount;
  final double distanceKm;
  final int sessions;
  final bool usedLiveLocation;

  WalkingProgress copyWith({
    int? stepCount,
    double? distanceKm,
    int? sessions,
    bool? usedLiveLocation,
  }) {
    return WalkingProgress(
      stepCount: stepCount ?? this.stepCount,
      distanceKm: distanceKm ?? this.distanceKm,
      sessions: sessions ?? this.sessions,
      usedLiveLocation: usedLiveLocation ?? this.usedLiveLocation,
    );
  }
}
