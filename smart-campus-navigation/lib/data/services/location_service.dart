import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Requests location permission, then returns the current device position.
  /// Returns null if permission is denied or location is unavailable.
  Future<Position?> getCurrentPosition() async {
    final status = await Permission.location.request();
    if (!status.isGranted) return null;

    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  /// Returns a continuous stream of device positions for live tracking.
  Stream<Position> getPositionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 3, // emit every 3 metres of movement
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  /// Opens the app's location permission settings page.
  Future<void> openLocationAppSettings() async {
    await openAppSettings();
  }
}
