import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/services/storage.service.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<UserModel> listUsers = [];
  final errorMessage = ValueNotifier<String>('');

  void getUsers() async {
    try {
      errorMessage.value = '';
      listUsers = await StorageService.getUsersList();
    } catch (e) {
      errorMessage.value = 'Erro ao carregar lista de usuários salvos.';
      debugPrint('Erro ao carregar lista de usuários: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) async {
    try {
      errorMessage.value = '';
      final success = await StorageService.removeUserFromList(user.login.uuid);
      if (success) {
        listUsers.remove(user);
      } else {
        errorMessage.value = 'Erro ao remover usuário. Tente novamente.';
      }
    } catch (e) {
      errorMessage.value = 'Erro ao remover usuário. Tente novamente.';
      debugPrint('Erro ao remover usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    getUsers();
  }

  @override
  void dispose() {
    errorMessage.dispose();
    super.dispose();
  }
}
