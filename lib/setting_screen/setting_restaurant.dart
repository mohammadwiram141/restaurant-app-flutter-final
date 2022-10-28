import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/local_notification_mgr.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/response/list_response.dart';

class SettingRestaurant extends StatefulWidget {
  final List<Restaurant> restaurants;

  const SettingRestaurant({super.key, required this.restaurants});

  @override
  State<StatefulWidget> createState() => SettingRestaurantState();
}

class SettingRestaurantState extends State<SettingRestaurant> {
  LocalNotificationManager? localNotificationManager;

  @override
  void initState() {
    super.initState();
    localNotificationManager =
        LocalNotificationManager(restaurants: widget.restaurants);
    Provider.of<RestaurantProvider>(context, listen: false).getValueSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SwitchListTile(
        title: const Text(
          "Restaurant Notification",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          Provider.of<RestaurantProvider>(context).isOn
              ? "Disable Notification"
              : "Enable Notification",
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black38,
            fontSize: 12,
          ),
        ),
        value: Provider.of<RestaurantProvider>(context).isOn,
        onChanged: (value) {
          Provider.of<RestaurantProvider>(context, listen: false)
              .saveValueSetting(value);
          Provider.of<RestaurantProvider>(context, listen: false)
              .getValueSetting();

          if (value) {
            localNotificationManager?.reminderDaily();
          } else {
            localNotificationManager?.cancelReminder();
          }
        },
      ),
    );
  }
}
