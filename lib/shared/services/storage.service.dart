import 'package:flutter/material.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'persistence.service.dart';

abstract class IStorageService {
  Future<bool> saveUserToList(UserModel user);
  Future<List<UserModel>> getUsersList();
  Future<bool> removeUserFromList(String userUuid);
  Future<bool> clearUsersList();
  Future<bool> isUserInList(String userUuid);
}

class StorageService implements IStorageService {
  static const String _usersListKey = 'saved_users_list';
  final IPersistenceService _persistence;

  StorageService(this._persistence);

  @override
  Future<bool> saveUserToList(UserModel user) async {
    try {
      final existingUsersData = await _persistence.loadList(_usersListKey);
      List<UserModel> usersList = existingUsersData
          .map((userMap) => UserModel.fromJson(userMap))
          .toList();

      final existingUserIndex = usersList.indexWhere(
        (u) => u.login.uuid == user.login.uuid,
      );
      if (existingUserIndex != -1) {
        usersList[existingUserIndex] = user;
      } else {
        usersList.add(user);
      }

      final updatedUsersJson = usersList.map((u) => u.toJson()).toList();
      final result = await _persistence.saveList(
        _usersListKey,
        updatedUsersJson,
      );

      if (result) {
        if (existingUserIndex != -1) {
          debugPrint('Usuário atualizado com sucesso na lista');
        } else {
          debugPrint('Usuário salvo com sucesso na lista');
        }
      }
      return result;
    } catch (e) {
      debugPrint('Erro ao salvar usuário na lista: $e');
      return false;
    }
  }

  @override
  Future<List<UserModel>> getUsersList() async {
    try {
      final usersData = await _persistence.loadList(_usersListKey);

      if (usersData.isNotEmpty) {
        final result = usersData
            .map((userMap) => UserModel.fromJson(userMap))
            .toList();
        debugPrint(
          'Lista de usuários carregada com sucesso: ${result.length} usuários',
        );
        return result;
      }
      debugPrint('Nenhum usuário salvo encontrado');
      return [];
    } catch (e) {
      debugPrint('Erro ao carregar lista de usuários: $e');
      return [];
    }
  }

  @override
  Future<bool> removeUserFromList(String userUuid) async {
    try {
      final usersData = await _persistence.loadList(_usersListKey);

      if (usersData.isNotEmpty) {
        List<UserModel> usersList = usersData
            .map((userMap) => UserModel.fromJson(userMap))
            .toList();

        usersList.removeWhere((user) => user.login.uuid == userUuid);

        final updatedUsersJson = usersList.map((u) => u.toJson()).toList();
        final result = await _persistence.saveList(
          _usersListKey,
          updatedUsersJson,
        );

        if (result) {
          debugPrint('Usuário removido com sucesso da lista');
        }
        return result;
      }
      return true;
    } catch (e) {
      debugPrint('Erro ao remover usuário da lista: $e');
      return false;
    }
  }

  @override
  Future<bool> clearUsersList() async {
    try {
      final result = await _persistence.delete(_usersListKey);
      if (result) {
        debugPrint('Lista de usuários limpa com sucesso');
      }
      return result;
    } catch (e) {
      debugPrint('Erro ao limpar lista: $e');
      return false;
    }
  }

  @override
  Future<bool> isUserInList(String userUuid) async {
    try {
      final usersData = await _persistence.loadList(_usersListKey);

      if (usersData.isEmpty) {
        return false;
      }

      return usersData.any((userMap) {
        final login = userMap['login'];
        if (login is Map<String, dynamic>) {
          return login['uuid'] == userUuid;
        }
        return false;
      });
    } catch (e) {
      debugPrint('Erro ao verificar usuário: $e');
      return false;
    }
  }
}
