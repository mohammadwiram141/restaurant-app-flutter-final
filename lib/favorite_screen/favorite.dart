class Favorite {
  Favorite({
    required this.idRestaurant,
    required this.name,
    required this.pictureId,
    required this.rating,
    required this.city,
  });

  String idRestaurant;
  String name;
  String pictureId;
  double rating;
  String city;

  factory Favorite.fromMap(Map<String, dynamic> item) => Favorite(
      idRestaurant: item["idRestaurant"],
      name: item["name"],
      pictureId: item["pictureId"],
      rating: item["rating"].toDouble(),
      city: item["city"]);

  Map<String, Object> toMap() {
    return {
      'idRestaurant': idRestaurant,
      'name': name,
      'pictureId': pictureId,
      'rating': rating,
      'city': city
    };
  }
}
