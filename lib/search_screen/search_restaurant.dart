import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/detail_screen/detail_restaurant.dart';
import 'package:restaurant/provider.dart';
import 'package:restaurant/response/search_response.dart';

class SearchRestaurant extends StatefulWidget {
  const SearchRestaurant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchRestaurantState();
}

class SearchRestaurantState extends State<SearchRestaurant> {
  String nama = "";
  bool isEmpty = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Restaurant"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Search",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: TextField(
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Provider.of<RestaurantProvider>(context, listen: false)
                      .search(value);
                  Provider.of<RestaurantProvider>(context, listen: false)
                      .setLoading(true);
                  setState(() {
                    isEmpty = false;
                  });
                } else {
                  setState(() {
                    isEmpty = true;
                  });
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: 'Search Restaurant',
                hintStyle: const TextStyle(fontFamily: 'Poppins',),
              ),
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
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Column(
                          children: const [
                            CircularProgressIndicator(),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                "Finding restaurant for you please wait",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Provider.of<RestaurantProvider>(context)
                          .getSearchResponse()
                          .restaurants
                          .isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isEmpty
                                ? 0
                                : Provider.of<RestaurantProvider>(context)
                                    .getSearchResponse()
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
                                              restaurantId: Provider.of<
                                                          RestaurantProvider>(
                                                      context)
                                                  .getSearchResponse()
                                                  .restaurants[index]
                                                  .id,
                                            ),
                                            transitionsBuilder:
                                                (c, anim, a2, child) =>
                                                    FadeTransition(
                                                        opacity: anim,
                                                        child: child),
                                            transitionDuration: const Duration(
                                                milliseconds: 1000),
                                          ),
                                        ),
                                      },
                                  child: RestaurantLayout(
                                      restaurants:
                                          Provider.of<RestaurantProvider>(
                                                  context)
                                              .getSearchResponse()
                                              .restaurants,
                                      position: index));
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: isEmpty ? const Text("") : const Text("Not Found"),
                          ),
                        ),
        ],
      ),
    );
  }
}

class RestaurantLayout extends StatelessWidget {
  final int position;
  final List<Restaurant>? restaurants;

  static const String imageUrl =
      "https://restaurant-api.dicoding.dev/images/small/";

  const RestaurantLayout(
      {Key? key, required this.restaurants, required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      height: 130,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrl + restaurants![position].pictureId,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurants![position].name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromRGBO(34, 34, 34, 1),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_location.svg",
                          width: 15,
                          height: 15,
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            restaurants![position].city,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black38,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(207, 75, 0, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 8, bottom: 8),
                            child: SvgPicture.asset(
                              "assets/images/ic_star.svg",
                              width: 15,
                              height: 15,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              restaurants![position].rating.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
