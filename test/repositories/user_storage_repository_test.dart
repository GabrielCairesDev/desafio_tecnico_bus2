import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/user_storage.repository.dart';
import 'package:desafio_tecnico_bus2/shared/services/storage.service.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements IStorageService {}

UserModel createFallbackUser() {
  return UserModel(
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
    email: 'test@example.com',
    login: Login(
      uuid: 'fallback-uuid',
      username: 'testuser',
      password: 'password',
      salt: 'salt',
      md5: 'md5',
      sha1: 'sha1',
      sha256: 'sha256',
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
}

void main() {
  group('UserStorageRepository', () {
    late UserStorageRepository repository;
    late MockStorageService mockStorageService;

    setUpAll(() {
      registerFallbackValue(createFallbackUser());
    });

    setUp(() {
      mockStorageService = MockStorageService();
      repository = UserStorageRepository(storageService: mockStorageService);
    });

    UserModel createTestUser(String uuid) {
      return UserModel(
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
          uuid: uuid,
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
    }

    group('saveUser', () {
      test('deve salvar usuário com sucesso', () async {
        final user = createTestUser('uuid-123');

        when(() => mockStorageService.saveUserToList(any())).thenAnswer((_) async => true);

        final result = await repository.saveUser(user);

        expect(result, true);
        verify(() => mockStorageService.saveUserToList(user)).called(1);
      });

      test('deve lançar exceção quando usuário não tem UUID válido', () async {
        final user = createTestUser('');

        expect(
          () => repository.saveUser(user),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });

      test('deve lançar exceção quando falha ao salvar', () async {
        final user = createTestUser('uuid-123');

        when(() => mockStorageService.saveUserToList(any())).thenAnswer((_) async => false);

        expect(
          () => repository.saveUser(user),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });

      test('deve lançar exceção quando ocorre erro inesperado', () async {
        final user = createTestUser('uuid-123');

        when(() => mockStorageService.saveUserToList(any())).thenThrow(Exception('Storage error'));

        expect(
          () => repository.saveUser(user),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });
    });

    group('getAllUsers', () {
      test('deve retornar lista de usuários salvos', () async {
        final user = createTestUser('uuid-123');
        final users = [user];

        when(() => mockStorageService.getUsersList()).thenAnswer((_) async => users);

        final result = await repository.getAllUsers();

        expect(result.length, 1);
        expect(result.first.login.uuid, 'uuid-123');
      });

      test('deve retornar lista vazia quando não há usuários', () async {
        when(() => mockStorageService.getUsersList()).thenAnswer((_) async => []);

        final result = await repository.getAllUsers();

        expect(result, isEmpty);
      });

      test('deve lançar exceção quando ocorre erro', () async {
        when(() => mockStorageService.getUsersList()).thenThrow(Exception('Storage error'));

        expect(
          () => repository.getAllUsers(),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });
    });

    group('removeUser', () {
      test('deve remover usuário com sucesso', () async {
        when(() => mockStorageService.removeUserFromList(any())).thenAnswer((_) async => true);

        final result = await repository.removeUser('uuid-123');

        expect(result, true);
        verify(() => mockStorageService.removeUserFromList('uuid-123')).called(1);
      });

      test('deve lançar exceção quando UUID está vazio', () async {
        expect(
          () => repository.removeUser(''),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });

      test('deve lançar exceção quando falha ao remover', () async {
        when(() => mockStorageService.removeUserFromList(any())).thenAnswer((_) async => false);

        expect(
          () => repository.removeUser('uuid-123'),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });

      test('deve lançar exceção quando ocorre erro inesperado', () async {
        when(() => mockStorageService.removeUserFromList(any())).thenThrow(Exception('Storage error'));

        expect(
          () => repository.removeUser('uuid-123'),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });
    });

    group('isUserSaved', () {
      test('deve retornar true quando usuário está salvo', () async {
        when(() => mockStorageService.isUserInList(any())).thenAnswer((_) async => true);

        final result = await repository.isUserSaved('uuid-123');

        expect(result, true);
        verify(() => mockStorageService.isUserInList('uuid-123')).called(1);
      });

      test('deve retornar false quando usuário não está salvo', () async {
        when(() => mockStorageService.isUserInList(any())).thenAnswer((_) async => false);

        final result = await repository.isUserSaved('uuid-123');

        expect(result, false);
      });

      test('deve retornar false quando UUID está vazio', () async {
        final result = await repository.isUserSaved('');

        expect(result, false);
      });

      test('deve lançar exceção quando ocorre erro', () async {
        when(() => mockStorageService.isUserInList(any())).thenThrow(Exception('Storage error'));

        expect(
          () => repository.isUserSaved('uuid-123'),
          throwsA(isA<UserStorageRepositoryException>()),
        );
      });
    });
  });
}
