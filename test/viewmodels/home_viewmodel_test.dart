import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/user.repository.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:desafio_tecnico_bus2/features/home/viewmodel/home.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/colored_test_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockTickerProvider extends Mock implements TickerProvider {}

void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel;
    late MockUserRepository mockUserRepository;
    late SelectedUserService selectedUserService;

    setUp(() {
      mockUserRepository = MockUserRepository();
      selectedUserService = SelectedUserService();
      viewModel = HomeViewModel(
        userRepository: mockUserRepository,
        selectedUserService: selectedUserService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    UserModel createTestUser(String email) {
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
        email: email,
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

    test('deve inicializar com lista vazia e sem erro', () {
      expect(viewModel.listUsers, isEmpty);
      expect(viewModel.errorMessage, '');
    });

    test('deve carregar usuários com sucesso', () async {
      final users = [
        createTestUser('user1@example.com'),
        createTestUser('user2@example.com'),
      ];

      when(() => mockUserRepository.getUsers()).thenAnswer((_) async => users);

      await viewModel.fetchUser();

      expect(viewModel.listUsers.length, 2);
      expect(viewModel.errorMessage, '');
      expect(viewModel.listUsers.first.email, 'user1@example.com');
    });

    test('deve adicionar novos usuários à lista existente', () async {
      final firstBatch = [createTestUser('user1@example.com')];
      final secondBatch = [createTestUser('user2@example.com')];

      when(
        () => mockUserRepository.getUsers(),
      ).thenAnswer((_) async => firstBatch);

      await viewModel.fetchUser();
      expect(viewModel.listUsers.length, 1);

      when(
        () => mockUserRepository.getUsers(),
      ).thenAnswer((_) async => secondBatch);

      await viewModel.fetchUser();
      expect(viewModel.listUsers.length, 2);
    });

    test(
      'deve definir mensagem de erro quando repositório lança exceção',
      () async {
        when(
          () => mockUserRepository.getUsers(),
        ).thenThrow(UserRepositoryException('Erro ao buscar usuários'));

        await viewModel.fetchUser();

        ColoredTestLogger.error(
          'Erro no repositório',
          'Erro ao buscar usuários',
        );
        expect(viewModel.errorMessage, 'Erro ao buscar usuários');
        expect(viewModel.listUsers, isEmpty);
      },
    );

    test(
      'deve definir mensagem de erro genérica quando ocorre erro inesperado',
      () async {
        when(
          () => mockUserRepository.getUsers(),
        ).thenThrow(Exception('Erro inesperado'));

        await viewModel.fetchUser();

        ColoredTestLogger.error(
          'Erro inesperado na requisição',
          'Erro inesperado',
        );
        expect(viewModel.errorMessage, isNotEmpty);
        expect(viewModel.listUsers, isEmpty);
      },
    );

    test('deve limpar mensagem de erro em nova busca bem-sucedida', () async {
      when(
        () => mockUserRepository.getUsers(),
      ).thenThrow(UserRepositoryException('Erro'));

      await viewModel.fetchUser();
      ColoredTestLogger.error('Erro no repositório', 'Erro');
      expect(viewModel.errorMessage, isNotEmpty);

      when(
        () => mockUserRepository.getUsers(),
      ).thenAnswer((_) async => [createTestUser('user@example.com')]);

      await viewModel.fetchUser();
      ColoredTestLogger.success('Busca bem-sucedida após erro');
      expect(viewModel.errorMessage, '');
      expect(viewModel.listUsers.length, 1);
    });

    test('deve prevenir múltiplas chamadas simultâneas', () async {
      final users = [createTestUser('user@example.com')];

      when(() => mockUserRepository.getUsers()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return users;
      });

      final future1 = viewModel.fetchUser();
      final future2 = viewModel.fetchUser();
      final future3 = viewModel.fetchUser();

      await Future.wait([future1, future2, future3]);

      verify(() => mockUserRepository.getUsers()).called(1);
    });

    test('deve definir usuário selecionado ao navegar para detalhes', () async {
      final user = createTestUser('user@example.com');
      final context = MockBuildContext();

      // Mock do Navigator para evitar erro de contexto
      try {
        await viewModel.navigateToDetails(context, user);
      } catch (e) {
        // Ignora erro de navegação, apenas verifica que o usuário foi definido
      }

      expect(selectedUserService.selectedUser, isNotNull);
      expect(selectedUserService.selectedUser?.email, 'user@example.com');
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
