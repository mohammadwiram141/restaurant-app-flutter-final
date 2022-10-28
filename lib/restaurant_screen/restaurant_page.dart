import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/restaurant_screen/item_layout.dart';

import '../detail_screen/detail_restaurant.dart';
import '../favorite_screen/favorite_restaurant.dart';
import '../provider.dart';
import '../search_screen/search_restaurant.dart';
import '../setting_screen/setting_restaurant.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isOnline = true;

  Future check() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        isOnline = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    check();
    Provider.of<RestaurantProvider>(context, listen: false).getAllRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => const FavoriteRestaurant(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  splashColor: Colors.white10,
                  child: SvgPicture.asset(
                    "assets/images/ic_love.svg",
                    width: 24,
                    height: 24,
                    color: Colors.black38,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => const SearchRestaurant(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  splashColor: Colors.white10,
                  child: SvgPicture.asset(
                    "assets/images/search.svg",
                    width: 24,
                    height: 24,
                    color: Colors.black38,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => SettingRestaurant(
                          restaurants: Provider.of<RestaurantProvider>(context)
                              .listResponse
                              .restaurants,
                        ),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  splashColor: Colors.white10,
                  child: SvgPicture.asset(
                    "assets/images/ic_settting.svg",
                    width: 24,
                    height: 24,
                    color: Colors.black38,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Recomendation restaurant for you!",
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
            ),
          ),
          !isOnline
              ? const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text("No Connection"),
                  ),
                )
              : Provider.of<RestaurantProvider>(context).isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: Provider.of<RestaurantProvider>(context)
                              .getListResponse()
                              .restaurants
                              .length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        DetailRestaurant(
                                      restaurantId:
                                          Provider.of<RestaurantProvider>(
                                                  context)
                                              .getListResponse()
                                              .restaurants[index]
                                              .id
                                    ),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                  ),
                                ),
                              },
                              child: ItemLayout(
                                  restaurants:
                                      Provider.of<RestaurantProvider>(context)
                                          .getListResponse()
                                          .restaurants,
                                  position: index),
                            );
                          }),
                    )
        ],
      ),
    );
  }
}
