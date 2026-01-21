import '../models/models.imports.dart';
import '../services/user.services.dart';
import '../exceptions/repository_exception.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getUsers();
}

class UserRepository implements IUserRepository {
  final IUserService _userService;

  UserRepository({required IUserService userService})
    : _userService = userService;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _userService.getUser();
      
      if (response.results.isEmpty) {
        throw UserRepositoryException(
          'Nenhum usuário retornado pela API',
        );
      }
      
      return response.results;
    } on UserRepositoryException {
      rethrow;
    } on Exception catch (e, stackTrace) {
      throw UserRepositoryException(
        'Erro ao buscar usuários da API',
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw UserRepositoryException(
        'Erro inesperado ao buscar usuários: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
