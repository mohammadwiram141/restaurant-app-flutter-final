import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/restaurant_screen/restaurant_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => RestaurantProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RestaurantPage(title: 'Restaurant'),
    );
  }
}
