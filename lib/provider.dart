import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/favorite_screen/favorite.dart';
import 'package:restaurant/request.dart';
import 'package:restaurant/response/detail_response.dart';
import 'package:restaurant/response/list_response.dart';
import 'package:restaurant/response/search_response.dart';
import 'package:restaurant/sqlite_component.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantProvider extends ChangeNotifier {
  SqliteComponent sqliteComponent = SqliteComponent();

  SearchResponse searchResponse = SearchResponse(
    error: true,
    founded: 0,
    restaurants: [],
  );

  ListResponse listResponse = ListResponse(
    error: true,
    message: "",
    count: 0,
    restaurants: [],
  );

  DetailResponse detailResponse = DetailResponse(
    error: true,
    message: "",
    restaurant: RestaurantDetail(
      id: "",
      name: "",
      description: "",
      city: "",
      address: "",
      pictureId: "",
      categories: [],
      menus: Menus(foods: [], drinks: []),
      rating: 0.0,
      customerReviews: [],
    ),
  );

  List<Favorite>? _favorites;

  List<Favorite>? get favorites => [...?_favorites];

  bool isOn = false;

  bool isLoading = true;

  bool isInFavorite = false;

  SearchResponse getSearchResponse() {
    return searchResponse;
  }

  ListResponse getListResponse() {
    return listResponse;
  }

  DetailResponse getDetailResponse() {
    return detailResponse;
  }

  void setLoading(bool load) {
    isLoading = load;
    notifyListeners();
  }

  void search(String searchValue) {
    searchRestaurant(searchValue)
        .then((value) => searchResponse = value)
        .whenComplete(() => {isLoading = false, notifyListeners()});
  }

  void getAllRestaurant() {
    fetchAllRestaurants(http.Client())
        .then((value) => listResponse = value)
        .whenComplete(() => {isLoading = false, notifyListeners()});
  }

  void getDetailRestaurant(String? id) {
    isLoading = true;
    fetchDetailRestaurant(id)
        .then((value) => detailResponse = value)
        .whenComplete(() => {isLoading = false, notifyListeners()});
  }

  void getAllFavorite() {
    sqliteComponent
        .getAllFavorites()
        .then((value) => _favorites = value)
        .whenComplete(() => {isLoading = false, notifyListeners()});
  }

  Future<bool?> getSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notification");
  }

  Future<void> saveSetting(bool notifOn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", notifOn);
  }

  void getValueSetting() {
    getSetting()
        .then((value) => isOn = value ?? false)
        .whenComplete(() => notifyListeners());
  }

  void saveValueSetting(bool notifOn) {
    saveSetting(notifOn).whenComplete(() => {notifyListeners()});
  }

  void queryFavorite(String idRestaurant) {
    sqliteComponent
        .getFavoriteById(idRestaurant)
        .then((value) => isInFavorite = value)
        .whenComplete(() => notifyListeners());
  }
}
