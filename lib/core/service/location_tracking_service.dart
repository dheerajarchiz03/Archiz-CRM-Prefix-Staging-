import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../features/databse/map_database.dart';


class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}

// Main Location Tracking Service
class LocationTrackingService {
  static const String _tag = "LocationTrackingService";
  static const String _channelId = "LocationTrackingChannel";
  static const int _notificationId = 1001;

  // Configuration constants
  static const Duration _updateInterval = Duration(seconds: 30);
  static const Duration _fastestUpdateInterval = Duration(seconds: 15);
  static const double _smallestDisplacement = 8.0; // meters
  static const double _maxAccuracyThreshold = 25.0; // meters

  // Singleton pattern
  static LocationTrackingService? _instance;

  static LocationTrackingService get instance {
    _instance ??= LocationTrackingService._internal();
    return _instance!;
  }

  LocationTrackingService._internal();

  // Service components
  Location? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  FlutterLocalNotificationsPlugin? _notificationsPlugin;
  MapLocalDataBase? _mapLocalDataBase;

  // Service state
  bool _isTrackingLocation = false;
  int _locationUpdateCount = 0;
  DateTime? _lastUpdateTime;

  // User data
  String? _userId;
  String? _compId;
  String? _visitId;

  // Location data
  LocationData? _currentLocation;
  StringBuffer _mapBuffer = StringBuffer();
  List<LatLng> _pathPoints = [];
  double _totalDistance = 0.0;
  LocationData? _lastLocation;
  DateTime _startTime = DateTime.now();

  // Stream controllers for broadcasting
  final StreamController<LocationData> _locationStreamController =
      StreamController<LocationData>.broadcast();

  Stream<LocationData> get locationStream => _locationStreamController.stream;

  // Initialize the service
  Future<void> initialize() async {
    debugPrint('$_tag: Initializing LocationTrackingService');

    _location = Location();
    _mapLocalDataBase = MapLocalDataBase();

    await _initializeNotifications();
    await _loadUserData();
    await _setupLocationConfiguration();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    _userId = (userId == null || userId.isEmpty) ? "123456" : userId;
    final compId = prefs.getString('company_id');
    _compId = (compId == null || compId.isEmpty) ? "888" : compId;
    _visitId = prefs.getString('visit_id');

    debugPrint(
      '$_tag: Loaded user data - userId: $_userId, compId: $_compId, visitId: $_visitId',
    );
    print(
      '$_tag: Loaded user data - userId: $_userId, compId: $_compId, visitId: $_visitId',
    );
  }

  // Setup location configuration
  Future<void> _setupLocationConfiguration() async {
    if (_location == null) return;

    // Check if location service is enabled
    bool serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) {
        debugPrint('$_tag: Location service not enabled');
        print('$_tag: Location service not enabled');
        return;
      }
    }

    // Check location permissions
    // PermissionStatus permissionGranted = await _location!.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await _location!.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     print('$_tag: Location permission not granted');
    //     return;
    //   }
    // }
    // Configure location settings
    // await _location!.changeSettings(
    //   accuracy: LocationAccuracy.balanced,
    //   interval: _updateInterval.inMilliseconds,
    //   distanceFilter: _smallestDisplacement,
    // );
    print('$_tag: Location configuration completed');
    print(
      '$_tag: Interval: ${_updateInterval.inMilliseconds}ms, ' 'Distance filter: ${_smallestDisplacement}m',
    );
  }
  // Initialize notifications
  Future<void> _initializeNotifications() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin!.initialize(initializationSettings);

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        'Location Tracking',
        description: 'Continuous location tracking for navigation',
        importance: Importance.low,
        showBadge: false,
        enableVibration: false,
        playSound: false,
      );

      await _notificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
    debugPrint('$_tag: Notifications initialized');
  }
  Timer? _pollingTimer;
  Future<void> startLocationTracking() async {
    if (_isTrackingLocation) {
      print('$_tag: Location tracking already active');
      return;
    }
    await WakelockPlus.enable();
    await _showLocationTrackingNotification();
    _isTrackingLocation = true;
    _lastUpdateTime = DateTime.now();
    _locationUpdateCount = 0;

    // Start periodic polling
    _pollingTimer = Timer.periodic(_updateInterval, (_) async {
      try {
        final locationData = await _location!.getLocation();
        _handleLocationUpdate(locationData);
      } catch (e) {
        print('$_tag: Error fetching location: $e');
      }
    });
    print('$_tag: Timer-based location tracking started');
  }
  Future<void> _stopLocationTracking() async {
    if (!_isTrackingLocation) return;

    print('$_tag: Stopping location tracking...');
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isTrackingLocation = false;

    await WakelockPlus.disable();
    await _notificationsPlugin?.cancel(_notificationId);
    print('$_tag: Location tracking stopped');
  }
  // Start location tracking
  // Future<void> startLocationTracking() async {
  //   if (_isTrackingLocation) {
  //     print('$_tag: ===>  Location tracking already active');
  //     return;
  //   }
  //   print('$_tag:====> Starting location tracking...');
  //   try {
  //     // Enable wakelock to prevent device sleep
  //     await WakelockPlus.enable();
  //     // Show persistent notification
  //     await _showLocationTrackingNotification();      // Start location updates
  //     _locationSubscription = _location!.onLocationChanged.listen(
  //       _handleLocationUpdate,
  //       onError: (error) {
  //         print('$_tag:---==> Location stream error: $error');
  //         _stopLocationTracking();
  //       },
  //     );
  //
  //     _isTrackingLocation = true;
  //     _lastUpdateTime = DateTime.now();
  //     _locationUpdateCount = 0;
  //     print(
  //       '$_tag: ----> Location tracking started successfully at ${_lastUpdateTime}',
  //     );
  //     print(
  //       '$_tag: Configuration:-----> ${_updateInterval.inSeconds}s interval, '
  //       '${_smallestDisplacement}m distance filter',
  //     );
  //   } catch (e) {
  //     print('$_tag:Error----->  Failed to start location tracking: $e');
  //     _isTrackingLocation = false;
  //     await WakelockPlus.disable();
  //     rethrow;
  //   }
  // }
  //
  // // Stop location tracking
  // Future<void> _stopLocationTracking() async {
  //   if (!_isTrackingLocation) return;
  //
  //   print('$_tag: Stopping location tracking...');
  //
  //   await _locationSubscription?.cancel();
  //   _locationSubscription = null;
  //   _isTrackingLocation = false;
  //
  //   // Disable wakelock
  //   await WakelockPlus.disable();
  //
  //   // Cancel notification
  //   await _notificationsPlugin?.cancel(_notificationId);
  //
  //   print('$_tag: Location tracking stopped successfully');
  // }

  // Handle location updates
  void _handleLocationUpdate(LocationData locationData) {
    final currentTime = DateTime.now();
    final timeSinceLastUpdate = _lastUpdateTime != null ? currentTime.difference(_lastUpdateTime!).inMilliseconds : 0;

    _locationUpdateCount++;

    print(
      '$_tag:==> Location update #$_locationUpdateCount received. '
      'Time since last: ${timeSinceLastUpdate}ms',
    );
    print(
      '$_tag:==> Location - Lat: ${locationData.latitude}, '
      'Lng: ${locationData.longitude}, '
      'Accuracy => : ${locationData.accuracy}m, '
      'Time: ${locationData.time}',
    );

    _currentLocation = locationData;
    _lastUpdateTime = currentTime;

    // Broadcast location update
    _locationStreamController.add(locationData);

    // Update notification
    _updateLocationTrackingNotification();

    // Process location if accuracy is acceptable
    if (locationData.accuracy != null &&
        locationData.accuracy! < _maxAccuracyThreshold) {
      _storeLocationInDatabase(locationData);
      print(
        '$_tag: >>>>> Location stored (accuracy: ${locationData.accuracy}m '
        '< ${_maxAccuracyThreshold}m threshold)',
      );
    } else {
      print(
        '$_tag:>>>> Location rejected due to poor accuracy: '
        '${locationData.accuracy}m >= ${_maxAccuracyThreshold}m',
      );
    }
    // Calculate distance if needed
    _calculateDistance(locationData);
  }

  // Store location in database
  Future<void> _storeLocationInDatabase(LocationData locationData) async {
    if (_userId == null || _mapLocalDataBase == null) return;
    try {
      print('$_tag: Starting database storage process...');

      final labels = await _mapLocalDataBase!.getDataByUser(_userId!);

      if (labels.isNotEmpty) {
        debugPrint(
          '$_tag: Found ${labels.length} existing records for user $_userId',
        );

        for (var label in labels) {
          if (label.location!.isNotEmpty) {
            final locationStr = label.location;
            final trimmedLocation = locationStr!.substring(
              0,
              locationStr!.length - 1,
            );
            _mapBuffer.write(
              '$trimmedLocation,[${locationData.latitude},${locationData.longitude}]]',
            );
          } else {
            _mapBuffer.write(
              '[[${locationData.latitude},${locationData.longitude}]]',
            );
          }
        }
      } else {
        debugPrint('$_tag: No existing records, creating new entry');
        _mapBuffer.write(
          '[[${locationData.latitude},${locationData.longitude}]]',
        );
      }
      print('$_tag: _mapBuffer $_mapBuffer');

      if (locationData.latitude != null &&
          locationData.longitude != null &&
          (locationData.latitude! != 0.0 || locationData.longitude! != 0.0)) {
        if (locationData.accuracy != null &&
            locationData.accuracy! < _maxAccuracyThreshold) {
          final newLabel = MapLabels(
            id: '',
            userID: _userId!,
            location: _mapBuffer.toString(),
          );

          bool exists = await _mapLocalDataBase!.isExist(_userId!);

          if (!exists) {
            await _mapLocalDataBase!.insertLocation(newLabel);
            debugPrint(
              '$_tag: New location record inserted for user: $_userId',
            );
            print('$_tag: New location record inserted for user: $_userId');
          } else {
            bool updateResult = await _mapLocalDataBase!.updateLocation(
              newLabel,
            );
            debugPrint(
              '$_tag: Location record updated for user $_userId: '
              '${updateResult ? "SUCCESS" : "FAILED"}',
            );
            print(
              '$_tag: Location record updated for user $_userId: '
              '${updateResult ? "SUCCESS" : "FAILED"}',
            );
          }

          _mapBuffer.clear();
        } else {
          _mapBuffer.clear();
          debugPrint(
            '$_tag: Location accuracy too poor: ${locationData.accuracy}m',
          );
          print('$_tag: Location accuracy too poor: ${locationData.accuracy}m');
        }
      } else {
        _mapBuffer.clear();
        debugPrint('$_tag: Invalid location coordinates (null or 0,0)');
      }
    } catch (e) {
      debugPrint('$_tag: Error in storeLocationInDatabase: $e');
      _mapBuffer.clear();
    }
  }

  // Calculate distance and speed
  void _calculateDistance(LocationData locationData) {
    if (locationData.latitude == null || locationData.longitude == null) return;

    final newPoint = LatLng(locationData.latitude!, locationData.longitude!);

    if (_lastLocation != null &&
        _lastLocation!.latitude != null &&
        _lastLocation!.longitude != null) {
      final segmentDistance = _calculateDistanceBetweenPoints(
        _lastLocation!.latitude!,
        _lastLocation!.longitude!,
        locationData.latitude!,
        locationData.longitude!,
      );

      _totalDistance += segmentDistance;

      final elapsedTime = DateTime.now().difference(_startTime);
      final avgSpeed = _totalDistance / elapsedTime.inSeconds; // m/s
      final avgSpeedKmph = avgSpeed * 3.6; // km/h

      print('$_tag: Distance ====> : ${_totalDistance / 1000}km, '
        'Time: ${elapsedTime.inMinutes}min, '
        'Avg Speed: ${avgSpeedKmph.toStringAsFixed(1)}km/h',
      );
    }
    _pathPoints.add(newPoint);
    _lastLocation = locationData;
  }

  // Calculate distance between two points using Haversine formula
  double _calculateDistanceBetweenPoints(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Show location tracking notification
  Future<void> _showLocationTrackingNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          'Location Tracking',
          channelDescription:
              'Tracking every 30 seconds for navigation services',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          showWhen: true,
          enableVibration: false,
          playSound: false,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: false,
          presentSound: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin?.show(
      _notificationId,
      '🗺️ Location Tracking Active',
      'Tracking every 30 seconds for navigation services',
      platformChannelSpecifics,
    );
  }

  // Update location tracking notification
  Future<void> _updateLocationTrackingNotification() async {
    final String contentText =
        'Updates: $_locationUpdateCount | '
        'Last: ${_lastUpdateTime != null ? _formatTime(_lastUpdateTime!) : "None"}';

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          'Location Tracking',
          channelDescription:
              'Tracking every 30 seconds for navigation services',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          showWhen: true,
          enableVibration: false,
          playSound: false,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: false,
          presentSound: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin?.show(
      _notificationId,
      '🗺️ Location Tracking (30s interval)',
      contentText,
      platformChannelSpecifics,
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  // Public methods
  bool get isTrackingLocation => _isTrackingLocation;

  LocationData? get currentLocation => _currentLocation;

  int get locationUpdateCount => _locationUpdateCount;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  List<LatLng> get pathPoints => List.unmodifiable(_pathPoints);

  double get totalDistance => _totalDistance;

  // Start the service
  Future<void> startService() async {
    await initialize();
    await startLocationTracking();
  }

  // Stop the service
  Future<void> stopService() async {
    await _stopLocationTracking();
    await _locationStreamController.close();
    await _mapLocalDataBase?.close();
  }

  // Dispose resources
  void dispose() {
    _locationStreamController.close();
    _stopLocationTracking();
  }
}
