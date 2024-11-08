import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  factory NotificationService() => _instance;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
