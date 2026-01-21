import 'package:desafio_tecnico_bus2/shared/models/user.model.dart';
import 'package:desafio_tecnico_bus2/shared/repositories/repositories.imports.dart';
import 'package:desafio_tecnico_bus2/shared/services/selected_user.service.dart';
import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  final IUserStorageRepository _userStorageRepository;
  final SelectedUserService _selectedUserService;

  bool isLoading = true;
  bool isUserSaved = false;
  UserModel? _selectedUser;
  final errorMessage = ValueNotifier<String>('');

  UserModel? get selectedUser => _selectedUser;

  DetailsViewModel({
    required IUserStorageRepository userStorageRepository,
    required SelectedUserService selectedUserService,
  }) : _userStorageRepository = userStorageRepository,
       _selectedUserService = selectedUserService;

  void initialize() {
    final user = _selectedUserService.selectedUser;

    if (user == null) {
      throw Exception(
        'Nenhum usuário selecionado. É necessário selecionar um usuário antes de navegar para detalhes.',
      );
    }

    _selectedUser = user;
    checkIfUserIsSaved(_selectedUser!.login.uuid);
  }

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
