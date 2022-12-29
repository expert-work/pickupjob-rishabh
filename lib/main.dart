import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/constants/constants.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'controllers/language_controller.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'dart:ui';

// ///////////////////FCM//////////////
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
  await setupInteractedMessage();
}

void showFlutterNotification(RemoteMessage message) {
  print("message comes");
  RemoteNotification? notification = message.notification;

  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
            color: const Color.fromRGBO(255, 255, 255, 1)),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermission(Permission.location);
  await requestPermission(Permission.notification);
  await Firebase.initializeApp(
    name: "Pickup Job",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  await FirebaseMessaging.instance.getToken().then((token) async {
    await setDeviceToken(token);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  await setupInteractedMessage();

  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });
  initializePlatformNotifications();

  Get.put<AuthController>(AuthController());
  Get.put<ThemeController>(ThemeController());
  Get.put<LanguageController>(LanguageController());
  runApp(MyApp());
}

setDeviceToken(deviceToken) {
  final getStorage = GetStorage();
  getStorage.write('deviceToken', deviceToken);
}

Future<void> requestPermission(Permission permission) async {
  final status = await permission.request();
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  print(message.data);
  print('On Background Notifiction CLick');
}

/*******************************
 * 
 * 
 * 
 * */
final _localNotifications = FlutterLocalNotificationsPlugin();

Future<void> initializePlatformNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_justwater');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await _localNotifications.initialize(initializationSettings,
      onDidReceiveNotificationResponse: selectNotification);
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {
  print('id $id');
}

Future<void> selectNotification(payload) async {
  print("FOGROUND CLICK ACTION END");
}
/******************************** */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetBuilder<LanguageController>(
      builder: (languageController) => Loading(
        child: GetMaterialApp(
          translations: Localization(),
          locale: languageController.getLocale,
          navigatorObservers: [
            // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: "/",
          getPages: AppRoutes.routes,
        ),
      ),
    );
  }
}
