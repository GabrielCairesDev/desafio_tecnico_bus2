import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';

class StorageService {
  static const String _usersListKey = 'saved_users_list';

  static Future<bool> saveUserToList(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final existingUsersJson = prefs.getString(_usersListKey);
      List<UserModel> usersList = [];

      if (existingUsersJson != null) {
        final List<dynamic> usersListData = jsonDecode(existingUsersJson);
        usersList = usersListData
            .map((userMap) => UserModel.fromJson(userMap))
            .toList();
      }

      final existingUserIndex = usersList.indexWhere(
        (u) => u.login.uuid == user.login.uuid,
      );
      if (existingUserIndex != -1) {
        usersList[existingUserIndex] = user;
      } else {
        usersList.add(user);
      }

      final updatedUsersJson = usersList.map((u) => u.toJson()).toList();
      final jsonString = jsonEncode(updatedUsersJson);

      final result = await prefs.setString(_usersListKey, jsonString);
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

  static Future<List<UserModel>> getUsersList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersListKey);

      if (usersJson != null) {
        final List<dynamic> usersList = jsonDecode(usersJson);
        final result = usersList
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

  static Future<bool> removeUserFromList(String userUuid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersListKey);

      if (usersJson != null) {
        final List<dynamic> usersListData = jsonDecode(usersJson);
        List<UserModel> usersList = usersListData
            .map((userMap) => UserModel.fromJson(userMap))
            .toList();

        usersList.removeWhere((user) => user.login.uuid == userUuid);

        final updatedUsersJson = usersList.map((u) => u.toJson()).toList();
        final jsonString = jsonEncode(updatedUsersJson);

        final result = await prefs.setString(_usersListKey, jsonString);
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

  static Future<bool> clearUsersList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_usersListKey);
      if (result) {
        debugPrint('Lista de usuários limpa com sucesso');
      }
      return result;
    } catch (e) {
      debugPrint('Erro ao limpar lista: $e');
      return false;
    }
  }

  static Future<bool> isUserInList(String userUuid) async {
    try {
      final users = await getUsersList();
      return users.any((user) => user.login.uuid == userUuid);
    } catch (e) {
      debugPrint('Erro ao verificar usuário: $e');
      return false;
    }
  }
}
