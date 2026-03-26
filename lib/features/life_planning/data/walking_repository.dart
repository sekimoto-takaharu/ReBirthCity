import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:rebirth_city/features/life_planning/domain/models/walking_progress.dart';

class WalkingRepository {
  const WalkingRepository();

  Future<WalkingProgress> syncWalking(WalkingProgress current) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _simulate(current);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _simulate(current);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final gainedDistanceKm = ((position.speed >= 0 ? position.speed : 0) * 1200) / 1000;
      final safeDistanceKm = gainedDistanceKm <= 0 ? 0.9 : gainedDistanceKm.clamp(0.6, 2.4);
      final gainedSteps = max(800, (safeDistanceKm * 1400).round());

      return current.copyWith(
        stepCount: current.stepCount + gainedSteps,
        distanceKm: current.distanceKm + safeDistanceKm,
        sessions: current.sessions + 1,
        usedLiveLocation: true,
      );
    } catch (_) {
      return _simulate(current);
    }
  }

  WalkingProgress _simulate(WalkingProgress current) {
    const gainedDistanceKm = 1.2;
    const gainedSteps = 1680;

    return current.copyWith(
      stepCount: current.stepCount + gainedSteps,
      distanceKm: current.distanceKm + gainedDistanceKm,
      sessions: current.sessions + 1,
      usedLiveLocation: false,
    );
  }
}
