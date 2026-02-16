import 'dart:developer';
import 'dart:io';

import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/themes.dart';
import 'package:archiz_staging_admin/common/controllers/localization_controller.dart';
import 'package:archiz_staging_admin/common/controllers/theme_controller.dart';
import 'package:archiz_staging_admin/features/lead/view/lead_screen.dart';
import 'package:archiz_staging_admin/features/task/view/add_task_screen.dart';
import 'package:archiz_staging_admin/features/ticket/view/add_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:home_widget/home_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/service/NotificationService.dart';
import 'core/service/di_services.dart' as services;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/lead/view/add_lead_screen.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  log("═══════════════════════════════════════════════════════════");
  log("🔔 BACKGROUND NOTIFICATION RECEIVED (Background Handler)");
  log("═══════════════════════════════════════════════════════════");
  log("Title: ${message.notification?.title ?? "No title"}");
  log("Body: ${message.notification?.body ?? "No body"}");
  log("Data: ${message.data}");
  log("Message ID: ${message.messageId}");
  log("═══════════════════════════════════════════════════════════");

  // Initialize local notifications in background isolate
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  await localNotifications.initialize(initSettings);

  // Create notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  await localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Show notification
  if (message.notification != null) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          showWhen: true,
        );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    // Extract phone number for payload
    String payload = '';
    if (message.data.containsKey('phone') ||
        message.data.containsKey('phone_number')) {
      payload = message.data['phone'] ?? message.data['phone_number'] ?? '';
    } else if (message.notification?.body != null) {
      payload = message.notification!.body!;
    }

    await localNotifications.show(
      message.notification.hashCode,
      '${message.notification?.title}- Main lead' ?? 'Notification',
      message.notification?.body ?? 'You have a new message',
      details,
      payload: payload,
    );
  }
}

Future<void> _requestCallPermission() async {
  var status = await Permission.phone.status;

  if (!status.isGranted) {
    final result = await Permission.phone.request();
    if (result.isGranted) {
      log('CALL_PHONE permission granted ✅');
    } else {
      log('CALL_PHONE permission denied ❌');
    }
  } else {
    log('CALL_PHONE permission already granted ✅');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HomeWidget.initialize(); // Initialize plugin
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Initialize services
  Map<String, Map<String, String>> languages = await services.init();

  // Set HTTP overrides
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Firebase
  await Firebase.initializeApp();
  await _requestCallPermission();
  // Register background message handler (must be called before runApp)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Notification Service (this will get FCM token)
  await NotificationService.initialize();

  // Get and log FCM token
  String? fcmToken = await NotificationService.getFCMToken();
  if (fcmToken != null) {
    log('🎯 FCM Token obtained: $fcmToken');
    log('💾 Token stored in SharedPreferences');
  } else {
    log('❌ Failed to get FCM token');
  }

// Read the route passed from Android (if any)
  const MethodChannel _channel = MethodChannel('flutter/navigation');
  String? initialRoute;

  try {
    final result = await _channel.invokeMethod('getInitialRoute');
    initialRoute = result as String?;
  } catch (_) {}

  runApp(MyApp(languages: languages,  initialRoute: initialRoute ?? '/',));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  final String initialRoute;
  @override
  State<MyApp> createState() => _MyAppState();
  const MyApp({super.key, required this.languages,required this.initialRoute});

}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _channel = MethodChannel('archiz/navigation');

  @override
  void initState() {
    super.initState();

    // ✅ Listen for navigation requests from Android
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'navigateTo') {
        final route = call.arguments as String?;
        if (route != null) {

          debugPrint("Navigating to $route from widget click");
          if (Get.isRegistered<GetMaterialApp>()) {
            Get.toNamed(route);
          } else {
            Get.toNamed(route);
          }
          // if(route.matchAsPrefix("/addLead") != null)
          // Get.toNamed(RouteHelper.addLeadScreen);
          // else if(route.matchAsPrefix("/addTask") != null)
          // Get.toNamed(RouteHelper.addTaskScreen);
          // else if(route.matchAsPrefix("/addTicket") != null)
          // Get.toNamed(RouteHelper.addTicketScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: LocalStrings.appName.tr,
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.noTransition,
              transitionDuration: const Duration(milliseconds: 100),
              initialRoute: RouteHelper.splashScreen,
              navigatorKey: Get.key,
              theme: theme.darkTheme ? dark : light,
              getPages: RouteHelper().routes,
              locale: localizeController.locale,
              translations: Messages(languages: widget.languages),
              fallbackLocale: Locale(
                localizeController.locale.languageCode,
                localizeController.locale.countryCode,
              ),
              routes: {
                '/addLead': (context) => const AddLeadScreen(),
                '/addTask': (context) => const AddTaskScreen(),
                '/addTicket': (context) => const AddTicketScreen(),
              },
            );
          },
        );
      },
    );
  }
}
