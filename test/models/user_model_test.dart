import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('deve criar um UserModel a partir de JSON válido', () {
      final json = {
        'gender': 'male',
        'name': {
          'title': 'Mr',
          'first': 'John',
          'last': 'Doe',
        },
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
        'dob': {
          'date': '1990-01-01T00:00:00.000Z',
          'age': 34,
        },
        'registered': {
          'date': '2020-01-01T00:00:00.000Z',
          'age': 4,
        },
        'phone': '123-456-7890',
        'cell': '987-654-3210',
        'id': {'name': 'SSN', 'value': '123-45-6789'},
        'picture': {
          'large': 'https://example.com/large.jpg',
          'medium': 'https://example.com/medium.jpg',
          'thumbnail': 'https://example.com/thumb.jpg',
        },
        'nat': 'US',
      };

      final user = UserModel.fromJson(json);

      expect(user.gender, 'male');
      expect(user.email, 'john.doe@example.com');
      expect(user.phone, '123-456-7890');
      expect(user.cell, '987-654-3210');
      expect(user.nat, 'US');
      expect(user.name.first, 'John');
      expect(user.name.last, 'Doe');
      expect(user.login.uuid, '123e4567-e89b-12d3-a456-426614174000');
    });

    test('deve criar um UserModel com valores padrão quando JSON está vazio', () {
      final user = UserModel.fromJson({});

      expect(user.gender, '');
      expect(user.email, '');
      expect(user.phone, '');
      expect(user.cell, '');
      expect(user.nat, '');
      expect(user.name.first, '');
      expect(user.login.uuid, '');
    });

    test('deve converter UserModel para JSON corretamente', () {
      final user = UserModel(
        gender: 'female',
        name: Name(title: 'Ms', first: 'Jane', last: 'Smith'),
        location: Location(
          street: Street(number: 456, name: 'Oak Ave'),
          city: 'Los Angeles',
          state: 'CA',
          country: 'USA',
          postcode: '90001',
          coordinates: Coordinates(latitude: '34.0522', longitude: '-118.2437'),
          timezone: Timezone(offset: '-8:00', description: 'Pacific Time'),
        ),
        email: 'jane.smith@example.com',
        login: Login(
          uuid: '987e6543-e21b-34c5-b567-537725285111',
          username: 'janesmith',
          password: 'pass456',
          salt: 'salt456',
          md5: 'md5hash2',
          sha1: 'sha1hash2',
          sha256: 'sha256hash2',
        ),
        dob: Dob(date: DateTime(1995, 5, 15), age: 29),
        registered: Registered(date: DateTime(2021, 3, 10), age: 3),
        phone: '555-123-4567',
        cell: '555-987-6543',
        id: Id(name: 'PASSPORT', value: 'AB123456'),
        picture: Picture(
          large: 'https://example.com/large2.jpg',
          medium: 'https://example.com/medium2.jpg',
          thumbnail: 'https://example.com/thumb2.jpg',
        ),
        nat: 'CA',
      );

      final json = user.toJson();

      expect(json['gender'], 'female');
      expect(json['email'], 'jane.smith@example.com');
      expect(json['phone'], '555-123-4567');
      expect(json['cell'], '555-987-6543');
      expect(json['nat'], 'CA');
      expect(json['name'], isA<Map<String, dynamic>>());
      expect(json['login'], isA<Map<String, dynamic>>());
    });

    test('deve fazer round-trip JSON corretamente', () {
      final originalJson = {
        'gender': 'male',
        'name': {
          'title': 'Mr',
          'first': 'John',
          'last': 'Doe',
        },
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
        'dob': {
          'date': '1990-01-01T00:00:00.000Z',
          'age': 34,
        },
        'registered': {
          'date': '2020-01-01T00:00:00.000Z',
          'age': 4,
        },
        'phone': '123-456-7890',
        'cell': '987-654-3210',
        'id': {'name': 'SSN', 'value': '123-45-6789'},
        'picture': {
          'large': 'https://example.com/large.jpg',
          'medium': 'https://example.com/medium.jpg',
          'thumbnail': 'https://example.com/thumb.jpg',
        },
        'nat': 'US',
      };

      final user = UserModel.fromJson(originalJson);
      final convertedJson = user.toJson();

      expect(convertedJson['gender'], originalJson['gender']);
      expect(convertedJson['email'], originalJson['email']);
      expect(convertedJson['phone'], originalJson['phone']);
    });
  });
}
