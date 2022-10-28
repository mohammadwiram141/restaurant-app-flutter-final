import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/request.dart';
import 'package:restaurant/response/list_response.dart';

import 'parsing_json_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchRestaurant', () {
    test('returns an restaurant if call completes successfully', () async {
      final client = MockClient();

      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((realInvocation) async => http.Response('{"error": false, "message": "test", "count": 1,"restaurants": [{"id":"test","name":"test","description":"test","pictureId":"14","city":"test","rating":4.2}]}', 200));
      expect(await fetchAllRestaurants(client), isA<ListResponse>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client
          .get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAllRestaurants(client), throwsException);
    });

  });
}
