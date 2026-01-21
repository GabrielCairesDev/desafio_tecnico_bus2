import 'dart:convert';
import 'package:desafio_tecnico_bus2/shared/services/user.services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('UserService', () {
    late UserService userService;
    late MockHttpClient mockHttpClient;

    setUpAll(() {
      registerFallbackValue(Uri.parse('https://example.com'));
      registerFallbackValue(<String, String>{});
    });

    setUp(() {
      mockHttpClient = MockHttpClient();
      userService = UserService(client: mockHttpClient);
    });

    test(
      'deve retornar ApiResponse quando a requisição é bem-sucedida',
      () async {
        final jsonResponse = {
          'results': [
            {
              'gender': 'male',
              'name': {'title': 'Mr', 'first': 'John', 'last': 'Doe'},
              'location': {
                'street': {'number': 123, 'name': 'Main St'},
                'city': 'New York',
                'state': 'NY',
                'country': 'USA',
                'postcode': '10001',
                'coordinates': {'latitude': '40.7128', 'longitude': '-74.0060'},
                'timezone': {'offset': '-5:00', 'description': 'Eastern Time'},
              },
              'email': 'john.doe@example.com',
              'login': {
                'uuid': '123e4567-e89b-12d3-a456-426614174000',
                'username': 'johndoe',
                'password': 'password123',
                'salt': 'salt123',
                'md5': 'md5hash',
                'sha1': 'sha1hash',
                'sha256': 'sha256hash',
              },
              'dob': {'date': '1990-01-01T00:00:00.000Z', 'age': 34},
              'registered': {'date': '2020-01-01T00:00:00.000Z', 'age': 4},
              'phone': '123-456-7890',
              'cell': '987-654-3210',
              'id': {'name': 'SSN', 'value': '123-45-6789'},
              'picture': {
                'large': 'https://example.com/large.jpg',
                'medium': 'https://example.com/medium.jpg',
                'thumbnail': 'https://example.com/thumb.jpg',
              },
              'nat': 'US',
            },
          ],
          'info': {'seed': 'abc123', 'results': 1, 'page': 1, 'version': '1.4'},
        };

        final response = http.Response(jsonEncode(jsonResponse), 200);

        when(
          () => mockHttpClient.get(
            any(that: isA<Uri>()),
            headers: any(named: 'headers', that: isA<Map<String, String>>()),
          ),
        ).thenAnswer((_) async => response);

        final result = await userService.getUser();

        expect(result.results.length, 1);
        expect(result.results.first.email, 'john.doe@example.com');
        expect(result.info.seed, 'abc123');
      },
    );

    test('deve lançar exceção quando status code não é 200', () async {
      final response = http.Response('Error', 404);

      when(
        () => mockHttpClient.get(
          any(that: isA<Uri>()),
          headers: any(named: 'headers', that: isA<Map<String, String>>()),
        ),
      ).thenAnswer((_) async => response);

      expect(() => userService.getUser(), throwsA(isA<Exception>()));
    });

    test('deve lançar exceção quando ocorre erro na requisição', () async {
      when(
        () => mockHttpClient.get(
          any(that: isA<Uri>()),
          headers: any(named: 'headers', that: isA<Map<String, String>>()),
        ),
      ).thenThrow(Exception('Network error'));

      expect(() => userService.getUser(), throwsA(isA<Exception>()));
    });
  });
}
