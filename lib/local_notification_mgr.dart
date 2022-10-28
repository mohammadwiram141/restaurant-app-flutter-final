import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/request.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/response/list_response.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin;
  List<Restaurant> restaurants;

  LocalNotificationManager({required this.restaurants}) {
    flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    var initSettings = const AndroidInitializationSettings(
      'daily_notification_icon',
    );
    flutterLocalNotificationPlugin
        .initialize(InitializationSettings(android: initSettings));
    tz.initializeTimeZones();
  }

  Future<void> cancelReminder() async {
    await flutterLocalNotificationPlugin.cancelAll();
  }

  Future<void> reminderDaily() async {
    var response = await fetchAllRestaurants(http.Client());
    List<Restaurant> restaurants = response.restaurants;
    Restaurant restaurant = (restaurants..shuffle()).first;

    var date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      11,
      0,
      0,
    );
    var androidDetails = const AndroidNotificationDetails(
      "CHANNEL_DAILY",
      "DAILY_NOTIFICATION",
      channelDescription: "Daily reminder",
      importance: Importance.max,
      priority: Priority.high,
    );

    var nDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationPlugin.zonedSchedule(254, "Restaurant",
        restaurant.name, tz.TZDateTime.from(date, tz.local), nDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
