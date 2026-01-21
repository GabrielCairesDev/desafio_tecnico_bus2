import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectedUserService', () {
    late SelectedUserService service;

    setUp(() {
      service = SelectedUserService();
    });

    test('deve inicializar sem usuário selecionado', () {
      expect(service.selectedUser, isNull);
      expect(service.hasSelectedUser, false);
    });

    test('deve definir usuário selecionado corretamente', () {
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

      service.setSelectedUser(user);

      expect(service.selectedUser, isNotNull);
      expect(service.hasSelectedUser, true);
      expect(service.selectedUser?.email, 'john.doe@example.com');
    });

    test('deve lançar ArgumentError ao tentar definir usuário sem UUID', () {
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
          uuid: '',
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

      expect(
        () => service.setSelectedUser(user),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('deve limpar usuário selecionado', () {
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

      service.setSelectedUser(user);
      expect(service.hasSelectedUser, true);

      service.clearSelectedUser();
      expect(service.selectedUser, isNull);
      expect(service.hasSelectedUser, false);
    });

    test('deve retornar e limpar usuário com takeSelectedUser', () {
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

      service.setSelectedUser(user);
      final takenUser = service.takeSelectedUser();

      expect(takenUser, isNotNull);
      expect(takenUser?.email, 'john.doe@example.com');
      expect(service.selectedUser, isNull);
      expect(service.hasSelectedUser, false);
    });
  });
}
