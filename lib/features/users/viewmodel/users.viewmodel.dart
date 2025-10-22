import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/services/storage.service.dart';
import 'package:flutter/material.dart';

class UsersViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<UserModel> listUsers = [];

  void getUsers() async {
    try {
      listUsers = await StorageService.getUsersList();
    } catch (e) {
      debugPrint('Erro ao carregar lista de usuários: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) async {
    try {
      await StorageService.removeUserFromList(user.login.uuid);
      listUsers.remove(user);
    } catch (e) {
      debugPrint('Erro ao remover usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> navigateToDetails(BuildContext context, UserModel user) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.details,
      arguments: user,
    );
    if (result == true) getUsers();
  }
}
