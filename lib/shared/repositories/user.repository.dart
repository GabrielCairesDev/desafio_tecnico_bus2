import '../models/models.imports.dart';
import '../services/user.services.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getUsers();
}

class UserRepository implements IUserRepository {
  final IUserService _userService;

  UserRepository({required IUserService userService})
    : _userService = userService;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _userService.getUser();
    return response.results;
  }
}
