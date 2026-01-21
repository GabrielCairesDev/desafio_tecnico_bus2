import '../models/user.model.dart';
import '../services/storage.service.dart';

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
    return await _storageService.saveUserToList(user);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    return await _storageService.getUsersList();
  }

  @override
  Future<bool> removeUser(String userUuid) async {
    return await _storageService.removeUserFromList(userUuid);
  }

  @override
  Future<bool> isUserSaved(String userUuid) async {
    return await _storageService.isUserInList(userUuid);
  }
}
