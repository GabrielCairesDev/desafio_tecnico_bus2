import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResponse', () {
    test('deve criar ApiResponse a partir de JSON válido', () {
      final json = {
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

      final apiResponse = ApiResponse.fromJson(json);

      expect(apiResponse.results.length, 1);
      expect(apiResponse.results.first.email, 'john.doe@example.com');
      expect(apiResponse.info.seed, 'abc123');
      expect(apiResponse.info.results, 1);
      expect(apiResponse.info.page, 1);
      expect(apiResponse.info.version, '1.4');
    });

    test(
      'deve criar ApiResponse com lista vazia quando results não existe',
      () {
        final json = {
          'info': {'seed': 'abc123', 'results': 0, 'page': 1, 'version': '1.4'},
        };

        final apiResponse = ApiResponse.fromJson(json);

        expect(apiResponse.results, isEmpty);
        expect(apiResponse.info.seed, 'abc123');
      },
    );

    test('deve converter ApiResponse para JSON corretamente', () {
      final user = UserModel(
        gender: 'male',
        name: Name(title: 'Mr', first: 'John', last: 'Doe'),
        location: Location(
          street: Street(number: 123, name: 'Main St'),
          city: 'New York',
          state: 'NY',
          country: 'USA',
          postcode: '10001',
          coordinates: Coordinates(latitude: '40.7128', longitude: '-74.0060'),
          timezone: Timezone(offset: '-5:00', description: 'Eastern Time'),
        ),
        email: 'john.doe@example.com',
        login: Login(
          uuid: '123e4567-e89b-12d3-a456-426614174000',
          username: 'johndoe',
          password: 'password123',
          salt: 'salt123',
          md5: 'md5hash',
          sha1: 'sha1hash',
          sha256: 'sha256hash',
        ),
        dob: Dob(date: DateTime(1990, 1, 1), age: 34),
        registered: Registered(date: DateTime(2020, 1, 1), age: 4),
        phone: '123-456-7890',
        cell: '987-654-3210',
        id: Id(name: 'SSN', value: '123-45-6789'),
        picture: Picture(
          large: 'https://example.com/large.jpg',
          medium: 'https://example.com/medium.jpg',
          thumbnail: 'https://example.com/thumb.jpg',
        ),
        nat: 'US',
      );

      final apiResponse = ApiResponse(
        results: [user],
        info: Info(seed: 'abc123', results: 1, page: 1, version: '1.4'),
      );

      final json = apiResponse.toJson();

      expect(json['results'], isA<List>());
      expect(json['results'].length, 1);
      expect(json['info'], isA<Map<String, dynamic>>());
      expect(json['info']['seed'], 'abc123');
    });
  });

  group('Info', () {
    test('deve criar Info a partir de JSON válido', () {
      final json = {
        'seed': 'test-seed',
        'results': 10,
        'page': 2,
        'version': '1.5',
      };

      final info = Info.fromJson(json);

      expect(info.seed, 'test-seed');
      expect(info.results, 10);
      expect(info.page, 2);
      expect(info.version, '1.5');
    });

    test('deve criar Info com valores padrão quando JSON está vazio', () {
      final info = Info.fromJson({});

      expect(info.seed, '');
      expect(info.results, 0);
      expect(info.page, 0);
      expect(info.version, '');
    });

    test('deve converter Info para JSON corretamente', () {
      final info = Info(
        seed: 'test-seed',
        results: 10,
        page: 2,
        version: '1.5',
      );

      final json = info.toJson();

      expect(json['seed'], 'test-seed');
      expect(json['results'], 10);
      expect(json['page'], 2);
      expect(json['version'], '1.5');
    });
  });
}
