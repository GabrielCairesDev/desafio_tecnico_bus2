import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/persistence.service.dart';
import 'package:desafio_tecnico_bus2/shared/services/storage.service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPersistenceService extends Mock implements IPersistenceService {}

void main() {
  group('StorageService', () {
    late StorageService storageService;
    late MockPersistenceService mockPersistence;

    setUp(() {
      mockPersistence = MockPersistenceService();
      storageService = StorageService(mockPersistence);
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

    test('deve salvar usuário na lista quando lista está vazia', () async {
      final user = createTestUser('uuid-123');

      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => []);
      when(() => mockPersistence.saveList(any(), any())).thenAnswer((_) async => true);

      final result = await storageService.saveUserToList(user);

      expect(result, true);
      verify(() => mockPersistence.loadList(any())).called(1);
      verify(() => mockPersistence.saveList(any(), any())).called(1);
    });

    test('deve atualizar usuário existente na lista', () async {
      final user = createTestUser('uuid-123');
      final existingUserData = [user.toJson()];

      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => existingUserData);
      when(() => mockPersistence.saveList(any(), any())).thenAnswer((_) async => true);

      final updatedUser = createTestUser('uuid-123');
      final result = await storageService.saveUserToList(updatedUser);

      expect(result, true);
      verify(() => mockPersistence.saveList(any(), any())).called(1);
    });

    test('deve retornar lista vazia quando não há usuários salvos', () async {
      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => []);

      final result = await storageService.getUsersList();

      expect(result, isEmpty);
    });

    test('deve retornar lista de usuários salvos', () async {
      final user = createTestUser('uuid-123');
      final userData = [user.toJson()];

      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => userData);

      final result = await storageService.getUsersList();

      expect(result.length, 1);
      expect(result.first.login.uuid, 'uuid-123');
    });

    test('deve remover usuário da lista', () async {
      final user = createTestUser('uuid-123');
      final userData = [user.toJson()];

      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => userData);
      when(() => mockPersistence.saveList(any(), any())).thenAnswer((_) async => true);

      final result = await storageService.removeUserFromList('uuid-123');

      expect(result, true);
      verify(() => mockPersistence.saveList(any(), any())).called(1);
    });

    test('deve verificar se usuário está na lista', () async {
      final user = createTestUser('uuid-123');
      final userData = [user.toJson()];

      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => userData);

      final result = await storageService.isUserInList('uuid-123');

      expect(result, true);
    });

    test('deve retornar false quando usuário não está na lista', () async {
      when(() => mockPersistence.loadList(any())).thenAnswer((_) async => []);

      final result = await storageService.isUserInList('uuid-123');

      expect(result, false);
    });

    test('deve limpar lista de usuários', () async {
      when(() => mockPersistence.delete(any())).thenAnswer((_) async => true);

      final result = await storageService.clearUsersList();

      expect(result, true);
      verify(() => mockPersistence.delete(any())).called(1);
    });
  });
}
