import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/detail_screen/detail_restaurant.dart';
import 'package:restaurant/favorite_screen/item_layout.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/sqlite_component.dart';

class FavoriteRestaurant extends StatefulWidget {
  const FavoriteRestaurant({super.key});

  @override
  State<StatefulWidget> createState() => FavoriteRestaurantState();
}

class FavoriteRestaurantState extends State<FavoriteRestaurant> {
  SqliteComponent sqliteComponent = SqliteComponent();
  
  Future<void> navigate(int index) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => DetailRestaurant(
          restaurantId: Provider.of<RestaurantProvider>(context)
              .favorites![index]
              .idRestaurant,
        ),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
    if (result.toString().isNotEmpty) {
      setState(() {
        Provider.of<RestaurantProvider>(context, listen: false).getAllFavorite();
      });
    }
  }
  

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantProvider>(context, listen: false).getAllFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurant"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 24.0,
              left: 16.0,
            ),
            child: Text(
              "My Favorite Restaurants",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount:
                Provider.of<RestaurantProvider>(context).favorites?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  navigate(index)
                },
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(
                    index.toString(),
                  ),
                  onDismissed: (direction) {
                    sqliteComponent.deleteFavorite(
                        Provider.of<RestaurantProvider>(context, listen: false)
                            .favorites![index]
                            .idRestaurant);
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .favorites
                        ?.removeAt(index);
                  },
                  child: ItemLayout(
                    favorites:
                        Provider.of<RestaurantProvider>(context).favorites,
                    position: index,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
