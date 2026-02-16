import 'dart:developer' as dev;
import 'location_tracking_service.dart';

/// LocationServiceManager - Helper class to start/stop the location tracking service
/// Direct Flutter conversion of the Android LocationServiceManager
class LocationServiceManager {
  static const String _tag = "ServiceManager";

  // Static reference to the location service instance
  static LocationTrackingService? _locationService;
  /// Start background location tracking service
  /// Flutter equivalent of the Android startLocationService method
  static Future<void> startLocationService() async {
    try {
      // Initialize service if not already created
      _locationService ??= LocationTrackingService.instance;
      // Start the location tracking service
      await _locationService!.startService();
      dev.log("Location service start requested", name: _tag);
    } catch (e) {
      dev.log("Failed to start location service: $e", name: _tag);
      rethrow;
    }
  }
  /// Stop background location tracking service
  /// Flutter equivalent of the Android stopLocationService method
  static Future<void> stopLocationService() async {
    try {
      if (_locationService != null) {
        await _locationService!.stopService();
      }
      dev.log("Location service stop requested", name: _tag);
    } catch (e) {
      dev.log("Failed to stop location service: $e", name: _tag);
      rethrow;
    }
  }
}