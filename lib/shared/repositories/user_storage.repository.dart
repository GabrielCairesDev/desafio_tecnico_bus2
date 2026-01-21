import '../models/user.model.dart';
import '../services/storage.service.dart';
import '../exceptions/repository_exception.dart';

abstract class IUserStorageRepository {
  Future<bool> saveUser(UserModel user);
  Future<List<UserModel>> getAllUsers();
  Future<bool> removeUser(String userUuid);
  Future<bool> isUserSaved(String userUuid);
}

class UserStorageRepository implements IUserStorageRepository {
  final IStorageService _storageService;

  UserStorageRepository({required IStorageService storageService})
    : _storageService = storageService;

  @override
  Future<bool> saveUser(UserModel user) async {
    try {
      if (user.login.uuid.isEmpty) {
        throw UserStorageRepositoryException(
          'Não é possível salvar usuário sem UUID válido',
        );
      }
      
      final success = await _storageService.saveUserToList(user);
      
      if (!success) {
        throw UserStorageRepositoryException(
          'Falha ao salvar usuário na persistência',
        );
      }
      
      return success;
    } on UserStorageRepositoryException {
      rethrow;
    } catch (e, stackTrace) {
      throw UserStorageRepositoryException(
        'Erro ao salvar usuário: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await _storageService.getUsersList();
      return users;
    } catch (e, stackTrace) {
      throw UserStorageRepositoryException(
        'Erro ao recuperar lista de usuários salvos: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> removeUser(String userUuid) async {
    try {
      if (userUuid.isEmpty) {
        throw UserStorageRepositoryException(
          'UUID do usuário não pode ser vazio',
        );
      }
      
      final success = await _storageService.removeUserFromList(userUuid);
      
      if (!success) {
        throw UserStorageRepositoryException(
          'Falha ao remover usuário da persistência',
        );
      }
      
      return success;
    } on UserStorageRepositoryException {
      rethrow;
    } catch (e, stackTrace) {
      throw UserStorageRepositoryException(
        'Erro ao remover usuário: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> isUserSaved(String userUuid) async {
    try {
      if (userUuid.isEmpty) {
        return false;
      }
      
      return await _storageService.isUserInList(userUuid);
    } catch (e, stackTrace) {
      throw UserStorageRepositoryException(
        'Erro ao verificar se usuário está salvo: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
