import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planlistapp/models/todo.dart';

class NotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationController() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(Todo todo) async {
    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Planlist',
      'PlanlistAppp',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule notifications for one day before and five minutes before
    final oneDayBefore = todo.dueDate.subtract(Duration(days: 1));
    final fiveMinutesBefore = todo.dueDate.subtract(Duration(minutes: 5));

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder: ${todo.title}',
      'One day left',
      oneDayBefore,
      platformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Reminder: ${todo.title}',
      'Five minutes left',
      fiveMinutesBefore,
      platformChannelSpecifics,
    );
  }
}
