import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/user_storage.repository.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:desafio_tecnico_bus2/shared/exceptions/repository_exception.dart';
import 'package:desafio_tecnico_bus2/features/details/viewmodel/details.viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/colored_test_logger.dart';

class MockUserStorageRepository extends Mock implements IUserStorageRepository {}

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
  group('DetailsViewModel', () {
    DetailsViewModel? viewModel;
    late MockUserStorageRepository mockStorageRepository;
    late SelectedUserService selectedUserService;

    setUpAll(() {
      registerFallbackValue(createFallbackUser());
    });

    setUp(() {
      mockStorageRepository = MockUserStorageRepository();
      selectedUserService = SelectedUserService();
    });

    tearDown(() {
      viewModel?.dispose();
      viewModel = null;
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

    test('deve inicializar com usuário selecionado', () {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => false);

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();

      expect(viewModel!.selectedUser, isNotNull);
      expect(viewModel!.selectedUser?.email, 'john.doe@example.com');
    });

    test('deve lançar exceção quando não há usuário selecionado', () {
      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      expect(
        () => viewModel!.initialize(),
        throwsA(isA<Exception>()),
      );
    });

    test('deve verificar se usuário está salvo ao inicializar', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => true);

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockStorageRepository.isUserSaved('uuid-123')).called(1);
    });

    test('deve salvar usuário quando não está salvo', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => false);
      when(() => mockStorageRepository.saveUser(any())).thenAnswer((_) async => true);

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel!.onPressSave(user);

      verify(() => mockStorageRepository.saveUser(user)).called(1);
      expect(viewModel!.isUserSaved, true);
    });

    test('deve remover usuário quando já está salvo', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => true);
      when(() => mockStorageRepository.removeUser(any())).thenAnswer((_) async => true);

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel!.onPressSave(user);

      verify(() => mockStorageRepository.removeUser('uuid-123')).called(1);
      expect(viewModel!.isUserSaved, false);
    });

    test('deve definir mensagem de erro quando falha ao salvar', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => false);
      when(() => mockStorageRepository.saveUser(any())).thenThrow(
        UserStorageRepositoryException('Erro ao salvar'),
      );

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel!.onPressSave(user);

      ColoredTestLogger.error('Erro no repositório de armazenamento', 'Erro ao salvar');
      expect(viewModel!.errorMessage, 'Erro ao salvar');
    });

    test('deve prevenir múltiplas chamadas simultâneas ao salvar', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => false);
      when(() => mockStorageRepository.saveUser(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return true;
      });

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 100));

      final future1 = viewModel!.onPressSave(user);
      final future2 = viewModel!.onPressSave(user);
      final future3 = viewModel!.onPressSave(user);

      await Future.wait([future1, future2, future3]);

      verify(() => mockStorageRepository.saveUser(user)).called(1);
      // Não fazer dispose aqui pois será feito no tearDown
    });

    test('deve limpar usuário selecionado ao fazer dispose', () async {
      final user = createTestUser('uuid-123');
      selectedUserService.setSelectedUser(user);

      when(() => mockStorageRepository.isUserSaved(any())).thenAnswer((_) async => false);

      viewModel = DetailsViewModel(
        userStorageRepository: mockStorageRepository,
        selectedUserService: selectedUserService,
      );

      // Verifica que o usuário está no serviço antes do initialize
      expect(selectedUserService.hasSelectedUser, true);

      viewModel!.initialize();
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Após initialize, o usuário foi "tomado" do serviço (takeSelectedUser)
      expect(selectedUserService.hasSelectedUser, false);
      expect(viewModel!.selectedUser, isNotNull);

      viewModel!.dispose();
      viewModel = null; // Evita dispose duplo no tearDown
      
      // Após dispose, o serviço deve continuar vazio (clearSelectedUser não faz nada se já está vazio)
      expect(selectedUserService.hasSelectedUser, false);
    });
  });
}
