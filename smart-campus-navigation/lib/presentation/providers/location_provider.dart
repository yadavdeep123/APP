import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Exposes a stream of live GPS positions
final locationStreamProvider = StreamProvider<Position>((ref) {
  final service = ref.watch(locationServiceProvider);
  return service.getPositionStream();
});

// One-time current position fetch
final currentPositionProvider = FutureProvider<Position?>((ref) async {
  final service = ref.read(locationServiceProvider);
  return service.getCurrentPosition();
});
