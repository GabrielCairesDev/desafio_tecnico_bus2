import 'package:desafio_tecnico_bus2/config/routes.config.dart';
import 'package:desafio_tecnico_bus2/shared/models/models.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/user.services.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<UserModel> listUsers = [];

  void onTick() async {
    try {
      final newUser = (await UserService.getUser()).results;
      listUsers.addAll(newUser);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro na requisição: $e');
    }
  }

  void navigateToUsers(BuildContext context) {
    Navigator.pushNamed(context, Routes.users);
  }

  void navigateToDetails(BuildContext context, UserModel user) {
    Navigator.pushNamed(context, Routes.details, arguments: user);
  }
}
