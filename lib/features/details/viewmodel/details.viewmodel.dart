import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;

  bool isLoading = true;
  bool isUserSaved = false;
  final errorMessage = ValueNotifier<String>('');

  DetailsViewModel({required IUserStorageRepository userStorageRepository})
    : _userStorageRepository = userStorageRepository;

  Future<void> onPressSave(UserModel user) async {
    try {
      errorMessage.value = '';
      if (isUserSaved) {
        final success = await _userStorageRepository.removeUser(
          user.login.uuid,
        );
        if (success) {
          isUserSaved = false;
        } else {
          errorMessage.value = 'Erro ao remover usuário. Tente novamente.';
        }
      } else {
        final success = await _userStorageRepository.saveUser(user);
        if (success) {
          isUserSaved = true;
        } else {
          errorMessage.value = 'Erro ao salvar usuário. Tente novamente.';
        }
      }
    } catch (e) {
      errorMessage.value = isUserSaved
          ? 'Erro ao remover usuário. Tente novamente.'
          : 'Erro ao salvar usuário. Tente novamente.';
      debugPrint('Erro ao salvar usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIfUserIsSaved(String userUuid) async {
    try {
      errorMessage.value = '';
      isUserSaved = await _userStorageRepository.isUserSaved(userUuid);
    } catch (e) {
      errorMessage.value = 'Erro ao verificar status do usuário.';
      debugPrint('Erro ao verificar usuário: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    errorMessage.dispose();
    super.dispose();
  }
}
