import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/favorite_screen/favorite.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/detail_screen/review_layout.dart';
import 'package:restaurant/sqlite_component.dart';

class DetailRestaurant extends StatefulWidget {
  const DetailRestaurant(
      {Key? key, required this.restaurantId})
      : super(key: key);

  final String? restaurantId;

  @override
  State<DetailRestaurant> createState() => DetailRestaurantState();
}

class DetailRestaurantState extends State<DetailRestaurant> {
  static const String imageUrl =
      "https://restaurant-api.dicoding.dev/images/large/";

  bool isOnline = true;

  SqliteComponent sqliteComponent = SqliteComponent();

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
    Provider.of<RestaurantProvider>(context, listen: false)
        .getDetailRestaurant(widget.restaurantId);
    Provider.of<RestaurantProvider>(context, listen: false)
        .queryFavorite(widget.restaurantId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, "Yes");
          return false;
        },
        child: !isOnline
            ? const Center(
                child: Text("No Connection"),
              )
            : Provider.of<RestaurantProvider>(context).isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.only(
                              bottomStart: Radius.circular(10),
                              bottomEnd: Radius.circular(10),
                            ),
                            image: DecorationImage(
                                image: NetworkImage(imageUrl +
                                    Provider.of<RestaurantProvider>(context)
                                        .getDetailResponse()
                                        .restaurant
                                        .pictureId),
                                fit: BoxFit.fill),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 16,
                                left: 16,
                                width: 50,
                                child: GestureDetector(
                                  onTap: () => {Navigator.pop(context)},
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/ic_back.svg",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<RestaurantProvider>(context)
                                            .getDetailResponse()
                                            .restaurant
                                            .name,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/ic_location.svg",
                                            width: 15,
                                            height: 15,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                              Provider.of<RestaurantProvider>(
                                                      context)
                                                  .getDetailResponse()
                                                  .restaurant
                                                  .city,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/ic_star.svg",
                                            width: 15,
                                            height: 15,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, top: 4),
                                            child: Text(
                                              Provider.of<RestaurantProvider>(
                                                      context)
                                                  .getDetailResponse()
                                                  .restaurant
                                                  .rating
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                width: 50,
                                height: 50,
                                bottom: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => {
                                    if (Provider.of<RestaurantProvider>(context,
                                            listen: false)
                                        .isInFavorite)
                                      {
                                        sqliteComponent
                                            .deleteFavorite(widget.restaurantId!)
                                      }
                                    else
                                      {
                                        sqliteComponent.addToFavorite(
                                          Favorite(
                                            idRestaurant:
                                                Provider.of<RestaurantProvider>(
                                                        context,
                                                        listen: false)
                                                    .getDetailResponse()
                                                    .restaurant
                                                    .id,
                                            name: Provider.of<RestaurantProvider>(
                                                    context,
                                                    listen: false)
                                                .getDetailResponse()
                                                .restaurant
                                                .name,
                                            pictureId:
                                                Provider.of<RestaurantProvider>(
                                                        context,
                                                        listen: false)
                                                    .getDetailResponse()
                                                    .restaurant
                                                    .pictureId,
                                            rating:
                                                Provider.of<RestaurantProvider>(
                                              context,
                                              listen: false,
                                            )
                                                    .getDetailResponse()
                                                    .restaurant
                                                    .rating,
                                            city: Provider.of<RestaurantProvider>(
                                                    context,
                                                    listen: false)
                                                .getDetailResponse()
                                                .restaurant
                                                .city,
                                          ),
                                        ),
                                      },
                                    Provider.of<RestaurantProvider>(context,
                                            listen: false)
                                        .queryFavorite(widget.restaurantId!)
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    color: Colors.white,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          "assets/images/ic_love.svg",
                                          color: Provider.of<RestaurantProvider>(
                                                      context)
                                                  .isInFavorite
                                              ? Colors.red
                                              : Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 32, top: 16),
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 32, top: 16, right: 32),
                          child: Column(
                            children: [
                              Text(
                                Provider.of<RestaurantProvider>(context)
                                    .getDetailResponse()
                                    .restaurant
                                    .description,
                                style: const TextStyle(
                                    color: Colors.black, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 32, top: 32),
                          child: Text(
                            "Our Menu",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Container(
                          height: 120,
                          padding: const EdgeInsets.only(left: 30, right: 32),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: Provider.of<RestaurantProvider>(context)
                                .getDetailResponse()
                                .restaurant
                                .menus
                                .foods
                                .length,
                            itemBuilder: (BuildContext context, int index) =>
                                Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: 91,
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/food.jpg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        Provider.of<RestaurantProvider>(context)
                                            .getDetailResponse()
                                            .restaurant
                                            .menus
                                            .foods[index]
                                            .name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 120,
                          padding: const EdgeInsets.only(left: 30, right: 32),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: Provider.of<RestaurantProvider>(context)
                                .getDetailResponse()
                                .restaurant
                                .menus
                                .drinks
                                .length,
                            itemBuilder: (BuildContext context, int index) =>
                                Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 91,
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/drink.jpg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        Provider.of<RestaurantProvider>(context)
                                            .getDetailResponse()
                                            .restaurant
                                            .menus
                                            .drinks[index]
                                            .name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            left: 32.0,
                          ),
                          child: Text(
                            "Customer Reviews",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Container(
                          height: 250,
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: Provider.of<RestaurantProvider>(context)
                                .getDetailResponse()
                                .restaurant
                                .customerReviews
                                .length,
                            itemBuilder: (context, index) {
                              return ReviewLayout(
                                cust: Provider.of<RestaurantProvider>(context)
                                    .getDetailResponse()
                                    .restaurant
                                    .customerReviews,
                                position: index,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
