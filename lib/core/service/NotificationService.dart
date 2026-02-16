import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archiz_staging_admin/core/helper/shared_preference_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize notification service
  static Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        log('Notification tapped: ${response.payload}');
        if (response.payload != null) {
          // Try to extract phone from payload
          String? phoneNumber = _extractPhoneNumber(response.payload!);
          if (phoneNumber != null) {
            await _openPhoneDialer(phoneNumber);
          }
        }
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Get FCM token
    await getFCMToken();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Log all notification details
      log('═══════════════════════════════════════════════════════════');
      log('🔔 FOREGROUND NOTIFICATION RECEIVED');
      log('═══════════════════════════════════════════════════════════');
      log('Title: ${message.notification?.title ?? "No title"}');
      log('Body: ${message.notification?.body ?? "No body"}');
      log('Data: ${message.data}');
      log('Message ID: ${message.messageId}');
      log('Sent Time: ${message.sentTime}');
      log('═══════════════════════════════════════════════════════════');
      
      // Show notification
      showNotification(message);
      
      // Show popup dialog with notification details
      _showNotificationDialog(message);
      
      // Extract phone number and open dialer automatically when notification is received
      _handleNotificationPhoneCall(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('═══════════════════════════════════════════════════════════');
      log('🔔 BACKGROUND NOTIFICATION OPENED');
      log('═══════════════════════════════════════════════════════════');
      log('Title: ${message.notification?.title ?? "No title"}');
      log('Body: ${message.notification?.body ?? "No body"}');
      log('Data: ${message.data}');
      log('═══════════════════════════════════════════════════════════');
      
      // Show popup dialog with notification details
      _showNotificationDialog(message);
      
      // Extract phone number and open dialer when notification is tapped
      _handleNotificationPhoneCall(message);
    });

    // Check if app was opened from a notification (terminated state)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      log('═══════════════════════════════════════════════════════════');
      log('🔔 APP OPENED FROM TERMINATED STATE');
      log('═══════════════════════════════════════════════════════════');
      log('Title: ${initialMessage.notification?.title ?? "No title"}');
      log('Body: ${initialMessage.notification?.body ?? "No body"}');
      log('Data: ${initialMessage.data}');
      log('═══════════════════════════════════════════════════════════');
      
      // Show popup dialog with notification details
      _showNotificationDialog(initialMessage);
      
      // Extract phone number and open dialer when app opened from notification
      _handleNotificationPhoneCall(initialMessage);
    }
  }

  // Get FCM token and store it
  static Future<String?> getFCMToken() async {
    try {
      // Request token
      String? token = await _firebaseMessaging.getToken();
      
      if (token != null) {
        log('Service FCM Token: $token');
        
        // Store token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPreferenceHelper.fcmTokenKey, token);
        
        // Token refresh listener
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          log('FCM Token refreshed: $newToken');
          prefs.setString(SharedPreferenceHelper.fcmTokenKey, newToken);
          // Optionally send new token to your server
          // sendTokenToServer(newToken);
        });
        
        return token;
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
    return null;
  }

  // Get stored FCM token
  static Future<String?> getStoredFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(SharedPreferenceHelper.fcmTokenKey);
    } catch (e) {
      log('Error getting stored FCM token: $e');
      return null;
    }
  }

  // Show notification
  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    // Include phone number in payload if available
    String payload = '';
    if (message.data.containsKey('phone') || message.data.containsKey('phone_number')) {
      payload = message.data['phone'] ?? message.data['phone_number'] ?? '';
    } else if (message.notification?.body != null) {
      // Store body in payload so we can extract phone from it on tap
      payload = message.notification!.body!;
    }
    await _notificationsPlugin.show(
      message.notification.hashCode,
      '${message.notification?.title} - Service Lead' ?? 'Notification',
      message.notification?.body ?? 'You have a new message',
      details,
      payload: payload,
    );
  }

  // Send FCM token to server (optional - implement based on your backend)
  static Future<void> sendTokenToServer(String token) async {
    try {
      // TODO: Implement API call to send token to your server
      // Example:
      // final response = await http.post(
      //   Uri.parse('YOUR_API_ENDPOINT/fcm-token'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'token': token}),
      // );
      log('Token sent to server: $token');
    } catch (e) {
      log('Error sending token to server: $e');
    }
  }

  // Extract phone number from notification body or data
  static String? _extractPhoneNumber(String text) {
    if (text.isEmpty) return null;
    
    log('Extracting phone number from: $text');
    
    // Pattern 1: Look for phone number in data payload format (JSON-like)
    // Try to extract from JSON strings or key-value pairs
    // Pattern 2: Look for international format (+ followed by digits)
    RegExp internationalPattern = RegExp(r'\+?[1-9]\d{9,14}');
    Match? match = internationalPattern.firstMatch(text);
    if (match != null) {
      String phoneNumber = match.group(0)!;
      log('Found international format: $phoneNumber');
      return phoneNumber;
    }
    
    // Pattern 3: Look for common phone number formats
    // (XXX) XXX-XXXX, XXX-XXX-XXXX, XXX.XXX.XXXX, XXX XXX XXXX
    RegExp commonPattern = RegExp(r'\b(\d{3}[-.\s]?\d{3}[-.\s]?\d{4})\b');
    match = commonPattern.firstMatch(text);
    if (match != null) {
      String phone = match.group(1)!.replaceAll(RegExp(r'[^\d]'), '');
      log('Found common format: $phone');
      return phone;
    }
    
    // Pattern 4: Look for any sequence of 10+ digits
    RegExp digitPattern = RegExp(r'\d{10,15}');
    match = digitPattern.firstMatch(text);
    if (match != null) {
      String phoneNumber = match.group(0)!;
      log('Found digit sequence: $phoneNumber');
      return phoneNumber;
    }
    
    // Pattern 5: Extract all digits and check if it's a valid phone number length
    String digitsOnly = text.replaceAll(RegExp(r'[^\d+]'), '');
    if (digitsOnly.length >= 10 && digitsOnly.length <= 15) {
      log('Found digits-only format: $digitsOnly');
      return digitsOnly;
    }
    
    log('No phone number pattern found in: $text');
    return null;
  }

  // Handle notification and extract phone number to call
  static Future<void> _handleNotificationPhoneCall(RemoteMessage message) async {
    try {
      log('═══════════════════════════════════════════════════════════');
      log('📞 PROCESSING PHONE NUMBER EXTRACTION');
      log('═══════════════════════════════════════════════════════════');
      
      String? phoneNumber;
      
      // First, check data payload for phone number
      log('Checking data payload...');
      log('Data keys: ${message.data.keys.toList()}');
      
      if (message.data.containsKey('phone') || message.data.containsKey('phone_number')) {
        phoneNumber = message.data['phone'] ?? message.data['phone_number'];
        log('✅ Phone number found in data: $phoneNumber');
      } else {
        log('❌ No phone key in data payload');
      }
      
      // If not in data, extract from notification body
      if (phoneNumber == null || phoneNumber.isEmpty) {
        String? body = message.notification?.body;
        log('Checking notification body: $body');
        if (body != null && body.isNotEmpty) {
          phoneNumber = _extractPhoneNumber(body);
          if (phoneNumber != null) {
            log('✅ Phone number extracted from body: $phoneNumber');
          } else {
            log('❌ No phone number found in body');
          }
        }
      }
      

      
      // Open phone dialer if phone number found
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        log('✅ Phone number confirmed: $phoneNumber');
        log('Opening phone dialer...');
        await _openPhoneDialer(phoneNumber);
      } else {
        log('❌ No phone number found in notification');
        log('Title: ${message.notification?.title}');
        log('Body: ${message.notification?.body}');
        log('Data: ${message.data}');
      }
      log('═══════════════════════════════════════════════════════════');
    } catch (e) {
      log('❌ Error handling notification phone call: $e');
      log('Error stack: ${e.toString()}');
    }
  }
  Future<void> _ensurePhonePermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }
  }
  static const platform = MethodChannel('com.archiz/call');

// Directly place a call (ACTION_CALL)
//   static Future<void> _openPhoneDialer(String phoneNumber) async {
//     try {
//       // Ensure permission before calling
//       // await _ensurePhonePermission();
//
//       // Clean up the number to remove unnecessary characters
//       String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
//
//       log('═══════════════════════════════════════════════════════════');
//       log('📞 ATTEMPTING TO MAKE DIRECT CALL');
//       log('═══════════════════════════════════════════════════════════');
//       log('Original number: $phoneNumber');
//       log('Cleaned number: $cleanedNumber');
//
//       // Invoke native Android code to make the call
//       await platform.invokeMethod('makeDirectCall', {'number': cleanedNumber});
//
//       log('✅ Direct call intent sent successfully');
//       log('═══════════════════════════════════════════════════════════');
//     } catch (e) {
//       log('❌ Error while making direct call: $e');
//     }
//   }
  /* =============================================*/
  // Open phone dialer with phone number
  static Future<void> _openPhoneDialer(String phoneNumber) async {
    try {
          // Clean up the phone number
          String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
          log('📞 Direct calling number: $cleanedNumber');

          // Trigger direct phone call
          bool? res = await FlutterPhoneDirectCaller.callNumber(cleanedNumber);

          if (res == true) {
            log('✅ Phone call initiated successfully');
          } else {
            log('❌ Failed to initiate call');
          }

      log('═══════════════════════════════════════════════════════════');
    } catch (e) {
      log('❌ Error opening phone dialer: $e');
      log('Error details: ${e.toString()}');
    }
  }

  // Show notification dialog popup
  static void _showNotificationDialog(RemoteMessage message) {
    try {
      // Use GetX to show dialog (works without context)
      // Small delay to ensure UI is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        try {
          String title = '${message.notification?.title}- Show Notif' ?? 'Notification';
          String body = message.notification?.body ?? 'You have a new message';
          Map<String, dynamic> data = message.data;
          
          // Extract phone number for display
          String? phoneNumber;
          if (data.containsKey('phone') || data.containsKey('phone_number')) {
            phoneNumber = data['phone'] ?? data['phone_number'];
          } else {
            phoneNumber = _extractPhoneNumber(body);
          }
          
          // Show dialog using GetX
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.blue, size: 30),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'New Notification',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Title:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Message:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      body,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (phoneNumber != null) ...[
                      const SizedBox(height: 15),
                      Text(
                        'Phone Number:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                    if (data.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        'Data:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close'),
                        ),
                        if (phoneNumber != null) ...[
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              _openPhoneDialer(phoneNumber!);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.phone, size: 18),
                                SizedBox(width: 5),
                                Text('Call'),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          );
          
          log('✅ Notification dialog shown');
        } catch (e) {
          log('❌ Error showing notification dialog: $e');
        }
      });
    } catch (e) {
      log('❌ Error preparing notification dialog: $e');
    }
  }
}