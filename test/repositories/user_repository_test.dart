import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/user.repository.dart';
import 'package:desafio_tecnico_bus2/shared/services/user.services.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements IUserService {}

void main() {
  group('UserRepository', () {
    late UserRepository repository;
    late MockUserService mockUserService;

    setUp(() {
      mockUserService = MockUserService();
      repository = UserRepository(userService: mockUserService);
    });

    UserModel createTestUser() {
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
    }

    test('deve retornar lista de usuários quando API retorna resultados', () async {
      final user = createTestUser();
      final apiResponse = ApiResponse(
        results: [user],
        info: Info(seed: 'abc123', results: 1, page: 1, version: '1.4'),
      );

      when(() => mockUserService.getUser()).thenAnswer((_) async => apiResponse);

      final result = await repository.getUsers();

      expect(result.length, 1);
      expect(result.first.email, 'john.doe@example.com');
      verify(() => mockUserService.getUser()).called(1);
    });

    test('deve lançar UserRepositoryException quando lista de resultados está vazia', () async {
      final apiResponse = ApiResponse(
        results: [],
        info: Info(seed: 'abc123', results: 0, page: 1, version: '1.4'),
      );

      when(() => mockUserService.getUser()).thenAnswer((_) async => apiResponse);

      expect(
        () => repository.getUsers(),
        throwsA(isA<UserRepositoryException>()),
      );
    });

    test('deve lançar UserRepositoryException quando serviço lança exceção', () async {
      when(() => mockUserService.getUser()).thenThrow(Exception('Network error'));

      expect(
        () => repository.getUsers(),
        throwsA(isA<UserRepositoryException>()),
      );
    });

    test('deve propagar UserRepositoryException quando já lançada', () async {
      when(() => mockUserService.getUser()).thenThrow(
        UserRepositoryException('Erro específico'),
      );

      expect(
        () => repository.getUsers(),
        throwsA(isA<UserRepositoryException>()),
      );
    });
  });
}
