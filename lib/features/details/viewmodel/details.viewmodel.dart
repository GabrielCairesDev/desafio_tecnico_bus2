import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/services/storage.service.dart';
import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  bool isLoading = true;
  bool isUserSaved = false;

  Future<void> onPressSave(UserModel user) async {
    try {
      if (isUserSaved) {
        await StorageService.removeUserFromList(user.login.uuid);
        isUserSaved = false;
      } else {
        await StorageService.saveUserToList(user);
        isUserSaved = true;
      }
    } catch (e) {
      debugPrint('Erro ao salvar usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIfUserIsSaved(String userUuid) async {
    try {
      isUserSaved = (await StorageService.isUserInList(userUuid));
    } catch (e) {
      debugPrint('Erro ao verificar usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
