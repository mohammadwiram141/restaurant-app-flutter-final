import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant/favorite_screen/favorite.dart';

class ItemLayout extends StatelessWidget {
  final int position;
  final List<Favorite>? favorites;

  static const String imageUrl =
      "https://restaurant-api.dicoding.dev/images/small/";

  const ItemLayout({Key? key, required this.favorites, required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
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
                    imageUrl + favorites![position].pictureId,
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
                      favorites![position].name,
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
                            favorites![position].city,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black38,
                              fontSize: 12,
                            ),
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
                              favorites![position].rating.toString(),
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
