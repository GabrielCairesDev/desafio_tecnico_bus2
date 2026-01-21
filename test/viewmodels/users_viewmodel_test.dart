import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/user_storage.repository.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:desafio_tecnico_bus2/features/users/viewmodel/users.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/colored_test_logger.dart';

class MockUserStorageRepository extends Mock implements IUserStorageRepository {}

void main() {
  group('UsersViewModel', () {
    late UsersViewModel viewModel;
    late MockUserStorageRepository mockStorageRepository;
    late SelectedUserService selectedUserService;

    setUp(() {
      mockStorageRepository = MockUserStorageRepository();
      selectedUserService = SelectedUserService();
      viewModel = UsersViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    UserModel createTestUser(String uuid, String email) {
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

    test('deve inicializar com lista vazia e loading true', () {
      expect(viewModel.listUsers, isEmpty);
      expect(viewModel.isLoading, true);
      expect(viewModel.errorMessage, '');
    });

    test('deve carregar lista de usuários salvos com sucesso', () async {
      final users = [
        createTestUser('uuid-1', 'user1@example.com'),
        createTestUser('uuid-2', 'user2@example.com'),
      ];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async => users);

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.listUsers.length, 2);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, '');
      expect(viewModel.listUsers.first.email, 'user1@example.com');
    });

    test('deve definir mensagem de erro quando repositório lança exceção', () async {
      when(() => mockStorageRepository.getAllUsers()).thenThrow(
        UserStorageRepositoryException('Erro ao carregar usuários'),
      );

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));

      ColoredTestLogger.error('Erro no repositório de armazenamento', 'Erro ao carregar usuários');
      expect(viewModel.errorMessage, 'Erro ao carregar usuários');
      expect(viewModel.isLoading, false);
      expect(viewModel.listUsers, isEmpty);
    });

    test('deve definir mensagem de erro genérica quando ocorre erro inesperado', () async {
      when(() => mockStorageRepository.getAllUsers()).thenThrow(Exception('Erro inesperado'));

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));

      ColoredTestLogger.error('Erro inesperado ao carregar lista de usuários', 'Erro inesperado');
      expect(viewModel.errorMessage, isNotEmpty);
      expect(viewModel.isLoading, false);
    });

    test('deve remover usuário da lista com sucesso', () async {
      final user1 = createTestUser('uuid-1', 'user1@example.com');
      final user2 = createTestUser('uuid-2', 'user2@example.com');
      final users = [user1, user2];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async => users);
      when(() => mockStorageRepository.removeUser(any())).thenAnswer((_) async => true);

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(viewModel.listUsers.length, 2);

      viewModel.removeUser(user1);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.listUsers.length, 1);
      expect(viewModel.listUsers.first.email, 'user2@example.com');
      verify(() => mockStorageRepository.removeUser('uuid-1')).called(1);
    });

    test('deve definir mensagem de erro quando falha ao remover usuário', () async {
      final user = createTestUser('uuid-1', 'user1@example.com');
      final users = [user];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async => users);
      when(() => mockStorageRepository.removeUser(any())).thenThrow(
        UserStorageRepositoryException('Erro ao remover'),
      );

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));
      viewModel.removeUser(user);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.errorMessage, 'Erro ao remover');
      expect(viewModel.listUsers.length, 1);
    });

    test('deve prevenir múltiplas chamadas simultâneas ao carregar', () async {
      final users = [createTestUser('uuid-1', 'user1@example.com')];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return users;
      });

      viewModel.getUsers();
      viewModel.getUsers();
      viewModel.getUsers();

      await Future.delayed(const Duration(milliseconds: 150));

      verify(() => mockStorageRepository.getAllUsers()).called(1);
    });

    test('deve prevenir múltiplas chamadas simultâneas ao remover', () async {
      final user = createTestUser('uuid-1', 'user1@example.com');
      final users = [user];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async => users);
      when(() => mockStorageRepository.removeUser(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return true;
      });

      viewModel.getUsers();
      await Future.delayed(const Duration(milliseconds: 50));

      viewModel.removeUser(user);
      viewModel.removeUser(user);
      viewModel.removeUser(user);

      await Future.delayed(const Duration(milliseconds: 150));

      verify(() => mockStorageRepository.removeUser('uuid-1')).called(1);
    });

    test('deve recarregar lista ao chamar refreshUsers', () async {
      final users = [createTestUser('uuid-1', 'user1@example.com')];

      when(() => mockStorageRepository.getAllUsers()).thenAnswer((_) async => users);

      viewModel.refreshUsers();
      await Future.delayed(const Duration(milliseconds: 50));

      verify(() => mockStorageRepository.getAllUsers()).called(1);
    });

    test('deve definir usuário selecionado ao navegar para detalhes', () async {
      final user = createTestUser('uuid-1', 'user1@example.com');
      final context = MockBuildContext();

      // Mock do Navigator para evitar erro de contexto
      try {
        await viewModel.navigateToDetails(context, user);
      } catch (e) {
        // Ignora erro de navegação, apenas verifica que o usuário foi definido
      }

      expect(selectedUserService.selectedUser, isNotNull);
      expect(selectedUserService.selectedUser?.email, 'user1@example.com');
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
