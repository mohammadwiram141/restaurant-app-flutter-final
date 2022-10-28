import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaurant/response/detail_response.dart';
import 'package:restaurant/response/list_response.dart';
import 'package:restaurant/response/search_response.dart';

const String baseUrl = "https://restaurant-api.dicoding.dev/";

Future<ListResponse> fetchAllRestaurants(http.Client client) async {
  try {
    final response = await client.get(Uri.parse("${baseUrl}list"));
    var jsonMap = jsonDecode(response.body);
    return ListResponse.fromJson(jsonMap);
  } on SocketException catch(_) {
    throw "No Internet Connection";
  }
}

Future<DetailResponse> fetchDetailRestaurant(String? id) async {
  try {
    final response = await http.get(Uri.parse("${baseUrl}detail/$id"));
    final jsonMap = json.decode(response.body);
    return DetailResponse.fromJson(jsonMap);
  } on SocketException catch(_) {
    throw "No Internet Connection";
  }
}

Future<SearchResponse> searchRestaurant(String nama) async {
  try {
    final response = await http.get(Uri.parse("${baseUrl}search?q=$nama"));
    final jsonMap = json.decode(response.body);
    return SearchResponse.fromJson(jsonMap);
  } on SocketException catch(_) {
    throw "No Internet Connection";
  }
}
