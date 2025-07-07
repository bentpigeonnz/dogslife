// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart'; // FlutterFire CLI generated
import 'core/themes/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'router.dart'; // Your GoRouter config

// 🟢 Local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// 🟢 Background FCM handler (must be top-level)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Optional: handle background notifications here
}

// 🟢 Initialize local notifications (in-app toast/banner)
Future<void> _initLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 Load .env (API keys, etc)
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🟢 Register background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🟢 Local notifications for in-app toasts
  await _initLocalNotifications();

  runApp(const ProviderScope(child: DogsLifeApp()));
}

class DogsLifeApp extends ConsumerStatefulWidget {
  const DogsLifeApp({super.key});

  @override
  ConsumerState<DogsLifeApp> createState() => _DogsLifeAppState();
}

class _DogsLifeAppState extends ConsumerState<DogsLifeApp> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    // 🟢 Ask for notification permissions (iOS, Web)
    await FirebaseMessaging.instance.requestPermission();

    // 🟢 Get device FCM token (can send to Firestore for this device/user)
    final token = await FirebaseMessaging.instance.getToken();
    setState(() => _fcmToken = token);
    debugPrint('🔔 FCM Token: $token');

    // 🟢 Listen for foreground messages (show toast/banner)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showInAppNotification(message);
    });

    // 🟢 Listen for notification taps (navigate if needed)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

  // 🟢 Show in-app notification as toast/banner & snackbar
  void _showInAppNotification(RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    // Show as banner/notification (system tray or overlay)
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dogs_life_channel',
          'DogsLife Alerts',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );

    // Show as snackbar in-app (optional, for quick UX)
    if (mounted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title\n$body')),
      );
    }
  }

  // 🟢 Handle taps (deep link via GoRouter, or show dialog)
  void _handleNotificationTap(RemoteMessage message) {
    final route = message.data['route'];
    if (route != null && context.mounted) {
      // TODO: Enable for deep-linking
      // context.go(route);
      debugPrint('User tapped notification, route: $route');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'dogsLife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        // Ensure global overlays/snackbars work everywhere
        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) => child!),
          ],
        );
      },
    );
  }
}
